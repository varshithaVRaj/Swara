//
//  WelcomeViewController.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
    }
    

    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] succes in
            DispatchQueue.main.async{
                self?.handleSignIn(success: succes)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func handleSignIn(success: Bool) {
        guard success else {
            // MARK: CREATING AN ALERT
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops",
                                              message: "Something went wrong while signing in", // Fixed typo
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            return
        }
        
        // Presenting main app tab bar controller
        DispatchQueue.main.async {
            let mainAppTabBarVc = TabBarViewController()
            mainAppTabBarVc.modalPresentationStyle = .fullScreen
            self.present(mainAppTabBarVc, animated: true)
        }
    }

  

}
