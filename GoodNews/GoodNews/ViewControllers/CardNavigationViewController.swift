//
//  CardNavigationViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class CardNavigationViewController: UINavigationController, Glideable {
    var headerHeight: CGFloat = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override init(rootViewController: UIViewController) {
        print("Hello")
        super.init(rootViewController: rootViewController)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
