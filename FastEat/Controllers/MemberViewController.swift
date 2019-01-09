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
        let view = LOTAnimationView(name: AnimationName.dinoDance)
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
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "姓名"
        setupBasicTextField(tf: tf)
        tf.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return tf
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "電郵地址"
        tf.keyboardType = .emailAddress
        setupBasicTextField(tf: tf)
        tf.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "密碼"
        tf.isSecureTextEntry = true
        setupBasicTextField(tf: tf)
        tf.snp.makeConstraints {
            $0.height.equalTo(50)
        }
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
        
        setupInputStackView()
        setupSegmentControl()
        setupAnimationView()
        setupRegisterBtn()
    }
    
    private func setupInputStackView(){
        view.addSubview(inputStackView)
        
        inputStackView.snp.makeConstraints {
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
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

    private func setupAnimationView() {
        view.addSubview(noodlesAnimationView)
        
        noodlesAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(segmentedControl.snp.top).offset(-10)
            $0.width.equalTo(175)
            $0.height.equalTo(175)
        }
    }
    
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
            
            UIView.animate(withDuration: 0.3) {
                self.inputStackView.arrangedSubviews.first?.alpha = 1
                self.inputStackView.arrangedSubviews.first?.isHidden = false
            }
            
            confirmBtn.setTitle("注冊", for: .normal)
        default:
            
            UIView.animate(withDuration: 0.3) {
                self.inputStackView.arrangedSubviews.first?.alpha = 0
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
