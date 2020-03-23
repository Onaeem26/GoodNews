//
//  TabViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let forYouController = UINavigationController(rootViewController: ForYouViewController())
        let forYouItem = UITabBarItem(title: "For You", image: UIImage(systemName: "heart.fill"), tag: 0)
        forYouController.tabBarItem = forYouItem
        
        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        let settingsItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        settingsController.tabBarItem = settingsItem
        
        let sourcesController = UINavigationController(rootViewController: SourcesViewController())
        let sourcesItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "tv.fill"), tag: 2)
        sourcesController.tabBarItem = sourcesItem
        
        let controllers = [forYouController, sourcesController, settingsController]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
 
    

}
