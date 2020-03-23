//
//  Configuration.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class Configuration: GlideConfiguration {
    var segmented: Bool = true
    var segmentHeightDictionary: [State : CGFloat] = [State.open : UIScreen.main.bounds.height - 60,
                                                      State.compressed : 350,
                                                      State.closed : 0]
    
    var concreteDimension: GlideConcreteDimension = .fullScreen
    var popUpIndicator: Bool = true

}
