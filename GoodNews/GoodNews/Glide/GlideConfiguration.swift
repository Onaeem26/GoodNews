//
//  GlideConfiguration.swift
//  GlideUI
//
//  Created by Osama Naeem on 24/10/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

enum GlideConcreteDimension {
    case fullScreen
    case half
    case oneFourth
    case oneThird
    case custom(CGFloat)
    
    func translateView(containerView parent: UIView, navControllerPresent: Bool) -> CGFloat {
        switch self {
        case .fullScreen:
            let parentHeight = parent.bounds.height
            var constraintConstant: CGFloat = 0
            let navBar: CGFloat = navControllerPresent ? 44 : 0
            constraintConstant = navBar
            return constraintConstant
        case .half:
            return (parent.bounds.height - parent.bounds.height / 2)
        case .oneFourth:
            return (parent.bounds.height - parent.bounds.height / 4)
        case .oneThird:
            return (parent.bounds.height - parent.bounds.height / 3)
        case let .custom(height):
            return (height > parent.bounds.height) ? parent.bounds.height: (parent.bounds.height - height)
        }
    }
}

protocol GlideConfiguration : class {
    
    ///When Segmentation Enabled, you get three States
    ///Open - Max Height
    ///Compressed - Middle Height
    ///Closed - Min Height of the card
    var segmented: Bool { get }
    
    ///When Segmentation is ENABLED
    ///A dictionary that takes the state enum (.open, .compressed, .closed) & corresponding heights
    var segmentHeightDictionary: [State: CGFloat] { get }
    
    
    
    ///If Segmentation is turned OFF
    ///Assign a concrete height to the card. It can be:
    ///Fullscreen - Takes the fullscreen of the parent view
    ///Half - half of the parent view
    ///OneFourth - 1/4 of the parent view
    ///OneThird - 1/3 of the parent View
    ///Custom - Give a custom dimension and it should open till that point.

    //Concrete Dimensions only have two states - close(0 or headerHeight) or opened (selected from above options)
    var concreteDimension: GlideConcreteDimension { get }
    
    
    //To show a grey handle top indicate this is a card/ interactable
    var popUpIndicator: Bool { get }
   
}
