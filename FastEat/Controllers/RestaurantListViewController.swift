//
//  RestaurantListViewController.swift
//  FastEat
//
//  Created by Danny LIP on 13/9/2018.
//  Copyright © 2018年 Danny LIP. All rights reserved.
//

import UIKit
import XLActionController
import GoogleMaps

class RestaurantListViewController: UIViewController {

    @IBOutlet private weak var restCountText: UILabel!
    @IBOutlet private weak var locationBtn: UIButton!
    @IBOutlet private weak var restListTableView: UITableView!
    
    private var restList: [Restaurant] = []
    private var userLocation = ""
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocations), name: NotificationName.didUpdateLocations, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initViews() {
        setupNavigationBar()
        setupLocationBtn()
        setupTableView()
        
        getRestaurantInfoByJson()
    }
    
    private func setupTableView() {
        refreshControl.addTarget(self, action: #selector(getRestaurantInfoByJson), for: .valueChanged)
        
        restListTableView.showsVerticalScrollIndicator = false
        restListTableView.addSubview(refreshControl)
        restListTableView.delegate = self
        restListTableView.dataSource = self
        restListTableView.delaysContentTouches = false
    }
    
    private func setupLocationBtn() {
        locationBtn.layer.cornerRadius = locationBtn.frame.size.height/2
        locationBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        locationBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    private func setupNavigationBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let backImage = UIImage(named: "lightOnDark")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        addNavBarImage()
    }
    
    private func addNavBarImage() {
        let image = #imageLiteral(resourceName: "icons8-food_truck-100")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navigationController?.navigationBar.frame.size.width ?? 0
        let bannerHeight = navigationController?.navigationBar.frame.size.height ?? 0
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @objc private func getRestaurantInfoByJson() {
        refreshControl.beginRefreshing()
        
        restList.removeAll()
        restListTableView.reloadData()
        
        APIManager.getRestaurantInfo { [weak self] (isSuccessful, restList) in
            self?.refreshControl.endRefreshing()
            
            if isSuccessful {
                if self?.userLocation == "" {
                    self?.restList = restList
                } else {
                    restList.forEach({ (rest) in
                        if self?.userLocation.range(of: rest.address) != nil {
                            self?.restList.append(rest)
                        }
                    })
                }
                self?.restCountText.text = "\(self?.restList.count ?? 0)間餐廳"
                self?.restListTableView.reloadData()
            } else {
                
                let alert = UIAlertController(title: "Error HTTP Request!", message: "Please retry again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { action in
                    self?.getRestaurantInfoByJson()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                self?.present(alert, animated: true)
            }
        }
    }
    
    private func updateRestListByUserAddress(userAddress: String) {
//        if userAddress == "" {
//            self.locationBtn.setTitle("所有餐廳", for: .normal)
//        } else {
        self.locationBtn.setTitle("現在位置： \(userAddress)", for: .normal)
//        }
        self.userLocation = userAddress
        self.getRestaurantInfoByJson()
    }

    @IBAction private func locationBtnDidTap(_ sender: AnyObject) {
        
        let actionSheet = CustomActionController()
        actionSheet.settings.animation.scale = nil
        actionSheet.headerData = "送餐地址"
        
//        actionSheet.addAction(Action(ActionData(title: "所有餐廳", image: UIImage(named: "store")!), style: .default, handler: { action in
//            self.updateRestListByUserAddress(userAddress: "")
//        }))
        actionSheet.addAction(Action(ActionData(title: "送餐到別的位置", image: UIImage(named: "map")!), style: .default, handler: { action in
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
            mapVC.locationDelegate = self
            
            let navCtrl = UINavigationController(rootViewController: mapVC)
            self.present(navCtrl, animated: true, completion: nil)
        }))
        actionSheet.addAction(Action(ActionData(title: "送餐到我的位置", image: UIImage(named: "placeholder")!), style: .default, handler: { action in
            LocationManager.shared.startUpdatingLocation()
        }))

        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func didUpdateLocations(notification: Notification) {
        if let location = notification.userInfo?["location"] as? CLLocation {
            let geocoder = GMSGeocoder()
            
            geocoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
                guard let address = response?.firstResult(), let lines = address.lines else {
                    return
                }
                self.updateRestListByUserAddress(userAddress: lines.joined(separator: "\n"))
            }
        }
        
        LocationManager.shared.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentityName.showRestDetailIden {
            let destVC = segue.destination as! RestaurantDetailViewController
            if let restaurant = sender as? Restaurant {
                destVC.restaurant = restaurant
            }
        }
    }
    
//    private let presentTransition = PresentTransition()
//    private var selectedCellContentFrame = CGRect()
//    private var selectedCell = RestaurantCell()
}

extension RestaurantListViewController: SelectedLocationDelegate {

    func didTapUserAddress(userAddress: String) {
        updateRestListByUserAddress(userAddress: userAddress)
    }
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: IdentityName.tableCellIden) as! RestaurantCell

        cell.setupRestaurant(restaurant: restaurant)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restList[indexPath.row]
        performSegue(withIdentifier: IdentityName.showRestDetailIden, sender: restaurant)
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        guard let cell = tableView.cellForRow(at: indexPath) as? RestaurantCell else { return }
//        cell.freezeAnimations()
//
//        let currentCellFrame = cell.restImageView.layer.presentation()!.frame
//        presentTransition.originFrame = cell.convert(currentCellFrame, to: nil)
//
//        selectedCellContentFrame = cell.convert(cell.restImageView.frame, to: nil)
//
//        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: showRestDetailIden) as! RestaurantDetailViewController
//        detailVC.restaurant = restList[indexPath.row]
//        detailVC.transitioningDelegate = self
//        detailVC.modalPresentationStyle = .overCurrentContext
//
//        present(detailVC, animated: true, completion: {
//            cell.unfreezeAnimations()
//            self.selectedCell = cell
//            cell.isHidden = true
//        })
    }
}

//extension RestaurantListViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return presentTransition
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        dismissTransition.toCellFrame = selectedCellContentFrame
//        return dismissTransition
//    }
//}
