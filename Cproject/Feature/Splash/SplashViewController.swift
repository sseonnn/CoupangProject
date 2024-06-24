//
//  SplashViewController.swift
//  Cproject
//
//  Created by 이정선 on 6/1/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lottieAnimationView.play { _ in
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: {$0.isKeyWindow}) {
                window.rootViewController = vc
            }
        }
    }
}
