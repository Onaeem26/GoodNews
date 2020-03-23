//
//  SelfConfiguringCell.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/17/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with article: Article)
}
