//
//  MemberViewController.swift
//  FastEat
//
//  Created by Danny LIP on 5/12/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class MemberViewController: UIViewController {

    private lazy var noodlesAnimationView: LOTAnimationView = {
        let view = LOTAnimationView(name: "noodles")
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["已有用戶", "新注冊"]
        let sc = UISegmentedControl(items: items)
        sc.tintColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .white
        sc.layer.cornerRadius = 5
        sc.addTarget(self, action: #selector(switchConfirmBtnText), for: .valueChanged)
        return sc
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "姓名"
        return tf
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "電郵地址"
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "密碼"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var nameSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(displayP3Red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        return line
    }()
    
    private lazy var emailSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(displayP3Red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        return line
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        btn.setTitle("登入", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
        noodlesAnimationView.loopAnimation = true
        noodlesAnimationView.animationSpeed = 0.5
        noodlesAnimationView.play()
    }

    private func initViews() {
        setupInputContainerView()
        setupSegmentControl()
        setupAnimationView()
        setupRegisterBtn()
    }
    
    private func setupAnimationView() {
        view.addSubview(noodlesAnimationView)
        
        noodlesAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(segmentedControl.snp.top).offset(-10)
            $0.width.equalTo(250)
            $0.height.equalTo(175)
        }
    }
    
    private func setupSegmentControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.bottom.equalTo(inputContainerView.snp.top).offset(-15)
            $0.height.equalTo(30)
        }
    }
    
    private func setupInputContainerView(){
        view.addSubview(inputContainerView)
        
        inputContainerView.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
            $0.height.equalTo(152)
        }
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorLine)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorLine)
        inputContainerView.addSubview(passwordTextField)
        
        nameTextField.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
            $0.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        nameSeparatorLine.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView.snp.leading)
            $0.trailing.equalTo(inputContainerView.snp.trailing)
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.height.equalTo(1)
        }
        
        emailTextField.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
            $0.top.equalTo(nameSeparatorLine.snp.bottom)
            $0.height.equalTo(50)
        }
        
        emailSeparatorLine.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView.snp.leading)
            $0.trailing.equalTo(inputContainerView.snp.trailing)
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
            $0.top.equalTo(emailSeparatorLine.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    private func setupRegisterBtn(){
        view.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.bottom.equalTo(inputContainerView).offset(60)
            $0.height.equalTo(40)
        }
    }
    
    @objc func switchConfirmBtnText(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            confirmBtn.setTitle("注冊", for: .normal)
        default:
            confirmBtn.setTitle("登入", for: .normal)
        }
    }
}
