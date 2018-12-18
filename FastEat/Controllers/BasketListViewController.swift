//
//  BasketListViewController.swift
//  FastEat
//
//  Created by Danny LIP on 26/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class BasketListViewController: UIViewController {

    var restaurant = Restaurant()
    var basketList = [FoodItem]()
    
    private var totalFoodFee = 0.0
    private let serviceFee = 20.0
    
    private var basketListTableView: UITableView!
    private var navBar: UINavigationBar!
    private let barHeight = UIApplication.shared.statusBarFrame.size.height
    
    private lazy var tableHeaderView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        return headerView
    }()
    
    private lazy var headerViewBaseline: UIView = {
        let baseline = UIView()
        baseline.backgroundColor = basketListTableView.separatorColor
        return baseline
    }()
    
    private lazy var restNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.sizeToFit()
        lbl.text = restaurant.restName
        return lbl
    }()
    
    private lazy var deliveryTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.text = "取餐時間・15-25 分鐘"
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var tableFooterView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        return footerView
    }()
    
    private lazy var footerViewTopline: UIView = {
        let topline = UIView()
        topline.backgroundColor = basketListTableView.separatorColor
        return topline
    }()
    
    private lazy var foodFeeTextLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.text = "小計"
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var foodFeeChargeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.sizeToFit()
        lbl.text = "$\(String(format: "%.2f", totalFoodFee))"
        return lbl
    }()
    
    private lazy var serviceFeeTextLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.text = "服務費"
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var serviceFeeChargeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.text = "$\(String(format: "%.2f", serviceFee))"
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var totalFeeTextLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "總計"
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var totalFeeChargeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.sizeToFit()
        lbl.text = "$\(String(format: "%.2f", totalFoodFee + serviceFee))"
        return lbl
    }()
    
    private lazy var checkOutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("開始結賬", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        btn.addTarget(self, action: #selector(handleCheckOut), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loadingAnimationView: LOTAnimationView = {
        let view = LOTAnimationView(name: "loading_rainbow")
        return view
    }()
    
    private lazy var checkedAnimationView: LOTAnimationView = {
        let view = LOTAnimationView(name: "checked_done_")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNavigationBar()
        
        calculateTotalCharge()

        setupTableView()
        setupHeaderView()
        setupFooterView()
        
        setupCheckOutBtn()
    }
    
    private func setupCheckOutBtn() {
        view.addSubview(checkOutBtn)
        
        checkOutBtn.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func calculateTotalCharge() {
        basketList.forEach { (foodItem) in
            let price = foodItem.price * Double(foodItem.quantity)
            totalFoodFee += price
        }
    }

    private func setupNavigationBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: barHeight, width: view.bounds.width, height: 44))
        navBar.barTintColor = .white
        
        self.view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "你的購物車")
        let closeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: nil, action: #selector(closeBasketList))
        
        navItem.leftBarButtonItem = closeItem
        navBar.setItems([navItem], animated: false)
    }
    
    private func setupTableView() {
        basketListTableView = UITableView(frame: CGRect(x: 0, y: barHeight + navBar.bounds.height + 1, width: view.bounds.width, height: view.bounds.height))
        basketListTableView.register(BasketListCell.self, forCellReuseIdentifier: "basketListCell")
        basketListTableView.delegate = self
        basketListTableView.dataSource = self
        basketListTableView.allowsSelection = false
        self.view.addSubview(basketListTableView)
    }
    
    private func setupHeaderView() {
        tableHeaderView.addSubview(restNameLbl)
        tableHeaderView.addSubview(deliveryTimeLbl)
        tableHeaderView.addSubview(headerViewBaseline)
        
        restNameLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(20)
        }
        
        deliveryTimeLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(restNameLbl).offset(35)
        }
        
        headerViewBaseline.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        basketListTableView.tableHeaderView = tableHeaderView
    }
    
    private func setupFooterView() {
        tableFooterView.addSubview(foodFeeTextLbl)
        tableFooterView.addSubview(foodFeeChargeLbl)
        tableFooterView.addSubview(serviceFeeTextLbl)
        tableFooterView.addSubview(serviceFeeChargeLbl)
        tableFooterView.addSubview(totalFeeTextLbl)
        tableFooterView.addSubview(totalFeeChargeLbl)
        tableFooterView.addSubview(footerViewTopline)
        
        foodFeeTextLbl.snp.makeConstraints {
            $0.leading.top.equalTo(15)
        }
        
        foodFeeChargeLbl.snp.makeConstraints {
            $0.trailing.equalTo(-15)
            $0.top.equalTo(15)
        }
        
        serviceFeeTextLbl.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.top.equalTo(foodFeeTextLbl).offset(35)
        }
        
        serviceFeeChargeLbl.snp.makeConstraints {
            $0.trailing.equalTo(-15)
            $0.top.equalTo(foodFeeChargeLbl).offset(35)
        }

        totalFeeTextLbl.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.top.equalTo(serviceFeeTextLbl).offset(35)
        }

        totalFeeChargeLbl.snp.makeConstraints {
            $0.trailing.equalTo(-15)
            $0.top.equalTo(serviceFeeChargeLbl).offset(35)
        }
        
        footerViewTopline.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        basketListTableView.tableFooterView = tableFooterView
    }
    
    @objc private func handleCheckOut() {
        
        basketListTableView.alpha = 0.5
        navBar.alpha = 0.5
        
        setupLoadingAnimationView()
        loadingAnimationView.animationSpeed = 0.7
        loadingAnimationView.play { (finished) in
            self.loadingAnimationView.stop()
            self.setupCheckedAnimationView()
            self.checkedAnimationView.play { (finished) in
                self.checkedAnimationView.stop()
                self.checkedAnimationView.removeFromSuperview()
                self.showSuccessCheckOutDialog()
            }
        }
        
    }
    
    private func setupLoadingAnimationView() {
        
        view.addSubview(loadingAnimationView)
        
        loadingAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(70)
        }
    }
    
    private func setupCheckedAnimationView() {
        
        view.addSubview(checkedAnimationView)
        
        checkedAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(200)
        }
    }
    
    private func showSuccessCheckOutDialog() {
        let successAlert = UIAlertController(title: "感謝你的訂單", message: "訂單已在處理中,請耐心等待取餐", preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .cancel) { (UIAlertAction) in
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        successAlert.addAction(action)
        self.present(successAlert, animated: true, completion: nil)
    }
    
    @objc private func closeBasketList() {
        dismiss(animated: true, completion: nil)
    }
}

extension BasketListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketListCell", for: indexPath) as! BasketListCell
        cell.setupFoodDetailCell(foodItem: basketList[indexPath.row])
        return cell
    }

}
