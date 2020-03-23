//
//  GlideDelegate.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/14/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

protocol GlideDelegate : class {
    func glideDidClose()
    func glideStateChangingFromOpenToCompress()
}

extension GlideDelegate {
    func glideStateChangingFromOpenToCompress() { }
}
