//
//  GNButton.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/22/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class GNButton : UIButton {
    
    required init(titleString : String) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        setTitle(titleString, for: .normal)
        layer.cornerRadius = 20
        setTitleColor(GNUIConfiguration.textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
