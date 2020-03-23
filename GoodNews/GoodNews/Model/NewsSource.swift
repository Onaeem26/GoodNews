//
//  NewsSource.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/15/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

struct NewsSource: Codable, Hashable {
    let id : String
    let name: String
    let country: String
    let description: String
    let url: String
    let category: String
}

struct Source : Codable {
    let sources: [NewsSource]
}
