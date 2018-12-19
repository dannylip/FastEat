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
        let view = LOTAnimationView(name: "dino_dance")
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["注冊", "已有用戶"]
        let sc = UISegmentedControl(items: items)
        sc.tintColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .white
        sc.layer.cornerRadius = 5
        sc.addTarget(self, action: #selector(switchContentText), for: .valueChanged)
        return sc
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "姓名"
        setupBasicTextField(tf: tf)
        return tf
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "電郵地址"
        setupBasicTextField(tf: tf)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "密碼"
        tf.isSecureTextEntry = true
        setupBasicTextField(tf: tf)
        return tf
    }()
    
    private func setupBasicTextField(tf: UITextField) {
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1.0
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor(displayP3Red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
    }
    
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
        noodlesAnimationView.play()
    }

    private func initViews() {
        
        view.addSubview(inputStackView)
        
        inputStackView.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
            $0.height.equalTo(152)
        }
//        setupInputContainerView()
        setupSegmentControl()
        setupAnimationView()
        setupRegisterBtn()
    }
    
    private func setupAnimationView() {
        view.addSubview(noodlesAnimationView)
        
        noodlesAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(segmentedControl.snp.top).offset(-10)
            $0.width.equalTo(175)
            $0.height.equalTo(175)
        }
    }
    
    private func setupSegmentControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.bottom.equalTo(inputStackView.snp.top).offset(-15)
            $0.height.equalTo(30)
        }
    }
    
//    private func setupInputContainerView(){
//        view.addSubview(inputContainerView)
//
//        inputContainerView.snp.makeConstraints {
//            $0.leading.equalTo(15)
//            $0.trailing.equalTo(-15)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalToSuperview().offset(12)
//            $0.height.equalTo(152)
//        }
//
//        inputContainerView.addSubview(nameTextField)
//        inputContainerView.addSubview(nameSeparatorLine)
//        inputContainerView.addSubview(emailTextField)
//        inputContainerView.addSubview(emailSeparatorLine)
//        inputContainerView.addSubview(passwordTextField)
//
//        nameTextField.snp.makeConstraints {
//            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
//            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
//            $0.top.equalToSuperview()
//            $0.height.equalTo(50)
//        }
//
//        nameSeparatorLine.snp.makeConstraints {
//            $0.leading.equalTo(inputContainerView.snp.leading)
//            $0.trailing.equalTo(inputContainerView.snp.trailing)
//            $0.top.equalTo(nameTextField.snp.bottom)
//            $0.height.equalTo(1)
//        }
//
//        emailTextField.snp.makeConstraints {
//            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
//            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
//            $0.top.equalTo(nameSeparatorLine.snp.bottom)
//            $0.height.equalTo(50)
//        }
//
//        emailSeparatorLine.snp.makeConstraints {
//            $0.leading.equalTo(inputContainerView.snp.leading)
//            $0.trailing.equalTo(inputContainerView.snp.trailing)
//            $0.top.equalTo(emailTextField.snp.bottom)
//            $0.height.equalTo(1)
//        }
//
//        passwordTextField.snp.makeConstraints {
//            $0.leading.equalTo(inputContainerView.snp.leading).offset(12)
//            $0.trailing.equalTo(inputContainerView.snp.trailing).offset(-12)
//            $0.top.equalTo(emailSeparatorLine.snp.bottom)
//            $0.height.equalTo(50)
//        }
//    }
    
    private func setupRegisterBtn(){
        view.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.bottom.equalTo(inputStackView).offset(60)
            $0.height.equalTo(40)
        }
    }
    
    @objc func switchContentText(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            inputStackView.snp.updateConstraints {
                $0.height.equalTo(152)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.inputStackView.arrangedSubviews.first?.isHidden = false
                self.view.layoutSubviews()
            }
            confirmBtn.setTitle("注冊", for: .normal)
        default:
            inputStackView.snp.updateConstraints {
                $0.height.equalTo(101)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.inputStackView.arrangedSubviews.first?.isHidden = true
            }
            confirmBtn.setTitle("登入", for: .normal)
        }
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
