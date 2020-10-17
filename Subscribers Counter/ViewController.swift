//
//  ViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 04.10.2020.
//

import UIKit

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        
        let accountsVC = AccountsViewController()
        let widgetsVC = WidgetsViewController()
        let infoVC = InfoViewController()
        
        accountsVC.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(named: "accounts"), tag: 0)
        widgetsVC.tabBarItem = UITabBarItem(title: "Widgets", image: UIImage(named: "widgets"), tag: 1)
        infoVC.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 2)
        
        let controllers = [accountsVC, widgetsVC, infoVC]
        
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    
    func firstTab() {
        self.selectedIndex = 0
    }
}

