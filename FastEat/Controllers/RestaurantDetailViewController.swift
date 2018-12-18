//
//  RestaurantDetailViewController.swift
//  FastEat
//
//  Created by Danny LIP on 9/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import SnapKit

class RestaurantDetailViewController: UIViewController {
    
    var restaurant = Restaurant()
    private lazy var menus: [Menu] = {
         return restaurant.menus
    }()
    
    private var basketList = [FoodItem]()
    private var selectedFoodItem: RestaurantFoodDetailCell!
    private var selectedIndexPath: IndexPath!
    private var finalFoodItemCount = 0
    private var checkMark = false
    private var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    @IBOutlet weak var foodListTableView: UITableView!
    @IBOutlet weak var restImageView: UIImageView!
    
    private lazy var addFoodItemView: UIView = {
        let addFoodView = UIView()
        addFoodView.backgroundColor = .white
        addFoodView.layer.cornerRadius = 5
        addFoodView.layer.shadowColor = UIColor.darkGray.cgColor
        addFoodView.layer.shadowRadius = 5
        addFoodView.layer.shadowOpacity = 0.5
        addFoodView.layer.shadowOffset = CGSize(width: 0, height: 0)
        return addFoodView
    }()
    
    private lazy var addFoodItemLabel: UILabel = {
        let foodNameLabel = UILabel()
        foodNameLabel.font = UIFont.boldSystemFont(ofSize: foodNameLabel.font.pointSize)
        foodNameLabel.font = foodNameLabel.font.withSize(24)
        foodNameLabel.text = "foodName"
        foodNameLabel.numberOfLines = 2
        foodNameLabel.textAlignment = .center
        return foodNameLabel
    }()
    
    private lazy var foodItemCountLabel: UILabel = {
        let foodCountLabel = UILabel()
        foodCountLabel.font = UIFont.boldSystemFont(ofSize: foodCountLabel.font.pointSize)
        foodCountLabel.font = foodCountLabel.font.withSize(30)
        foodCountLabel.text = "0"
        foodCountLabel.numberOfLines = 0
        foodCountLabel.textAlignment = .center
        return foodCountLabel
    }()
    
    private lazy var addFoodButton: UIButton = {
        let addFoodBtn = UIButton(type: .custom)
        let addFoodImage = UIImage(named: "plus")
        addFoodBtn.setImage(addFoodImage, for: .normal)
        addFoodBtn.addTarget(self, action: #selector(addFoodCount), for: .touchUpInside)
        return addFoodBtn
    }()
    
    private lazy var minusFoodButton: UIButton = {
        let minusFoodBtn = UIButton(type: .custom)
        let minusFoodImage = UIImage(named: "minus")
        minusFoodBtn.setImage(minusFoodImage, for: .normal)
        minusFoodBtn.addTarget(self, action: #selector(minusFoodCount), for: .touchUpInside)
        return minusFoodBtn
    }()
    
    private lazy var confirmAddToBasketButton: UIButton = {
        let addToBasketButton = UIButton(type: .system)
        addToBasketButton.setTitle("確認", for: .normal)
        addToBasketButton.setTitleColor(.white, for: .normal)
        addToBasketButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addToBasketButton.backgroundColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        addToBasketButton.layer.cornerRadius = 15
        addToBasketButton.addTarget(self, action: #selector(confirmAddToBasket), for: .touchUpInside)
        return addToBasketButton
    }()
    
    private lazy var checkBasketListButton: UIButton = {
        let checkBasketLisrBtn = UIButton(type: .system)
        checkBasketLisrBtn.setTitle("查看購物車", for: .normal)
        checkBasketLisrBtn.setTitleColor(.white, for: .normal)
        checkBasketLisrBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        checkBasketLisrBtn.backgroundColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        checkBasketLisrBtn.addTarget(self, action: #selector(checkBasketList), for: .touchUpInside)
        return checkBasketLisrBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        setupTableHeaderView()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupFoodImage()
        
        setupFoodListTableView()
        
        view.addSubview(checkBasketListButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCheckBasketListButton()
        
        foodListTableView.snp.remakeConstraints {
            $0.bottom.equalTo(checkBasketListButton.snp.top)
        }

    }
    
    private func setupFoodListTableView() {
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.showsVerticalScrollIndicator = false
        foodListTableView.snp.makeConstraints {
            $0.bottom.equalTo(0)
        }
    }
    
    private func setupFoodImage() {
        if let restImageUrl = URL(string: restaurant.restImageUrl) {
            restImageView.af_setImage(withURL: restImageUrl)
        } else {
            restImageView.image = UIImage()
        }
    }
    
    @IBAction private func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        basketList.forEach { (foodItem) in
            foodItem.quantity = 0
        }
    }
    
    private func setupAddFoodItemView() {
        
        view.addSubview(addFoodItemView)
        
        addFoodItemView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(50)
            $0.trailing.equalTo(-50)
        }
        
        addFoodItemView.addSubview(addFoodItemLabel)
        addFoodItemView.addSubview(foodItemCountLabel)
        addFoodItemView.addSubview(addFoodButton)
        addFoodItemView.addSubview(minusFoodButton)
        addFoodItemView.addSubview(confirmAddToBasketButton)
        
        addFoodItemLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
        }
        
        foodItemCountLabel.snp.makeConstraints {
            $0.top.equalTo(addFoodItemLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        addFoodButton.snp.makeConstraints {
            $0.centerY.equalTo(foodItemCountLabel)
            $0.leading.equalTo(foodItemCountLabel).inset(45)
            $0.width.height.equalTo(40)
        }
        
        minusFoodButton.snp.makeConstraints {
            $0.centerY.equalTo(foodItemCountLabel)
            $0.trailing.equalTo(foodItemCountLabel).inset(45)
            $0.width.height.equalTo(40)
        }
        
        confirmAddToBasketButton.snp.makeConstraints {
            $0.centerX.equalTo(addFoodItemView)
            $0.top.equalTo(addFoodButton.snp.bottom).offset(16)
            $0.bottom.equalTo(addFoodItemView).inset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
    
    private func setupCheckBasketListButton() {
        if checkBasketListButton.constraints.isEmpty {
            checkBasketListButton.snp.makeConstraints {
                $0.height.bottom.equalTo(view.safeAreaInsets.bottom + 50)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func showBasketListButton() {

        checkBasketListButton.snp.updateConstraints {
            $0.bottom.equalTo(0)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutSubviews()
        }

    }
    
    private func hideBasketListButton() {
        
        checkBasketListButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom + 50)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutSubviews()
        }
        
    }
    
    @objc private  func addFoodCount() {
        var addFoodCount = Int(foodItemCountLabel.text!) ?? 0
        addFoodCount += 1
        foodItemCountLabel.text = "\(addFoodCount)"
    }
    
    @objc private func minusFoodCount() {
        var minusFoodCount = Int(foodItemCountLabel.text!) ?? 0
        if minusFoodCount != 0 {
            minusFoodCount -= 1
            foodItemCountLabel.text = "\(minusFoodCount)"
        }
    }
    
    @objc private func confirmAddToBasket() {
        updateBasketList()
        addFoodItemViewAnimateOut()
    }
    
    private func updateBasketList() {
        finalFoodItemCount = Int(foodItemCountLabel.text!) ?? 0
        
        let currentSelectedFoodItem = menus[selectedIndexPath.section].foodItems[selectedIndexPath.row]
        
        if finalFoodItemCount == 0 {
            basketList.removeAll {
                $0 === currentSelectedFoodItem
            }
        } else {
            basketList.append(currentSelectedFoodItem)
        }
        
        currentSelectedFoodItem.quantity = finalFoodItemCount
        
        foodListTableView.reloadData()
        
        if basketList.isEmpty {
            hideBasketListButton()
        } else {
            showBasketListButton()
        }
        
        //        print("Start:")
        //        basketList.forEach { (foodItem) in
        //
        //            print(foodItem.name)
        //            print(foodItem.price)
        //            print(foodItem.quantity)
        //
        //        }
        //        print("End:\n")
    }
    
    @objc private func checkBasketList() {
        let basketListViewController = BasketListViewController()
        basketListViewController.basketList = basketList
        basketListViewController.restaurant = restaurant
        present(basketListViewController, animated: true)
    }
    
    private func addFoodItemViewAnimateIn() {
        
        setupAddFoodItemView()

        addFoodItemView.center = self.view.center
        addFoodItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        addFoodItemView.alpha = 0
        
        addFoodItemLabel.text = selectedFoodItem.foodItemLbl.text
        
        foodItemCountLabel.text = "0"
        
        UIView.animate(withDuration: 0.4) {
            self.addFoodItemView.alpha = 1
            self.addFoodItemView.transform = CGAffineTransform.identity
        }
    }
    
    private func addFoodItemViewAnimateOut() {
    
        UIView.animate(withDuration: 0.3, animations: {
            self.addFoodItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.addFoodItemView.alpha = 0
        }) { (success:Bool) in
            self.addFoodItemView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    
    private func startBlurEffect() {
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

}

extension RestaurantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentityName.foodItemtableCellIden, for: indexPath) as! RestaurantFoodDetailCell
        
        cell.setupFoodDetailCell(foodItem: menus[indexPath.section].foodItems[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodItem = tableView.cellForRow(at: indexPath) as? RestaurantFoodDetailCell
        selectedIndexPath = indexPath
        
        startBlurEffect()
        
        addFoodItemViewAnimateIn()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//func setupTableHeaderView() {
//    tableView.showsVerticalScrollIndicator = false
//    tableView.estimatedRowHeight = tableView.rowHeight
//    tableView.rowHeight = UITableViewAutomaticDimension
//
//    headerView = foodListTableView.tableHeaderView as? RestaurantDetailHeaderView
//    headerView.restImageUrl = restaurant.restImageUrl
//    tableView.tableHeaderView = nil
//
//    tableView.addSubview(headerView)
//
//    tableView.contentInset = UIEdgeInsetsMake(tableHeaderViewHeight, 0, 0, 0)
//    tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight)
//
//    cut away the header view
//    headerMaskLayer = CAShapeLayer()
//    headerMaskLayer.fillColor = UIColor.black.cgColor
//    headerView.layer.mask = headerMaskLayer
//
//    let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway / 2
//    tableView.contentInset = UIEdgeInsetsMake(effectiveHeight, 0, 0, 0)
//    tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
//
//    updateHeaderView()
//}
//
//func updateHeaderView() {
//    let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway / 2
//    var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
//
//    if tableView.contentOffset.y < -effectiveHeight {
//        headerRect.origin.y = tableView.contentOffset.y
//        headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutaway/2
//    }
//
//    headerView.frame = headerRect
//    print(headerRect)
//
//    let path = UIBezierPath()
//    path.move(to: CGPoint(x: 0, y: 0))
//    path.addLine(to: CGPoint(x: headerRect.width, y: 0))
//    path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
//    path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderViewCutaway))
//
//    headerMaskLayer?.path = path.cgPath
//}
