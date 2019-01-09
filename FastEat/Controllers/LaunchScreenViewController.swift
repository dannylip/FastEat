//
//  LaunchScreenViewController.swift
//  FastEat
//
//  Created by Danny LIP on 2/12/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class LaunchScreenViewController: UIViewController {

    private var timer = Timer()
    
    private lazy var truckRunningAnimationView: LOTAnimationView = {
        let view = LOTAnimationView(name: AnimationName.truckRunning)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTruckRunningAnimationView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        truckRunningAnimationView.loopAnimation = true
        truckRunningAnimationView.animationSpeed = 1.5
        truckRunningAnimationView.play()
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(goToMainScreen), userInfo: nil, repeats: true)

    }

    private func setupTruckRunningAnimationView() {
        
        view.addSubview(truckRunningAnimationView)
        
        truckRunningAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(165)
            $0.height.equalTo(200)
        }
    }
    
    @objc private func goToMainScreen() {
        
        timer.invalidate()
        
        if let window = UIApplication.shared.keyWindow,
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: IdentityName.tabBarControllerIden)
        {
            window.rootViewController = tabBarController
        }
    }
}
