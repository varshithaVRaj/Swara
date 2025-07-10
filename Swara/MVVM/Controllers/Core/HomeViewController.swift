//
//  ViewController.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector (didTapSetting))
        
    }
    
    
    @objc func didTapSetting(){
        
//        let vc = ProfileViewController()
//        vc.title = "Profile"
//        vc.navigationItem.largeTitleDisplayMode = .never 
//        navigationController?.pushViewController(vc, animated: true)
        
        let vc = SettingsViewController()
            vc.title = "Settings"
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        
    
    }


}

