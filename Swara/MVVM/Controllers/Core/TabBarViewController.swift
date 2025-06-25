//
//  TabBarViewController.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = LibraryViewController()
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Library"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let navVc1 = UINavigationController(rootViewController: vc1)
        let navVc2 = UINavigationController(rootViewController: vc2)
        let navVc3 = UINavigationController(rootViewController: vc3)
        
        navVc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "house"), tag: 1)
        navVc2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "magnifying"), tag: 1)
        navVc2.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "house"), tag: 1)
        
        navVc1.navigationBar.prefersLargeTitles = true
        navVc2.navigationBar.prefersLargeTitles = true
        navVc3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navVc1, navVc2, navVc3], animated: false)
     
    }
    

    

}
