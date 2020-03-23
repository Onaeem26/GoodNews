//
//  Sources.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/21/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.


import UIKit

enum sectionType {
    
    case NewsSources
    case Topics
}
struct Channel: Hashable {
    let identifier: UUID = UUID() 
    let sectionType: sectionType
    var sites: [NewsSource]
    var topics: [String]
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }

    static func == (lhs: Channel, rhs: Channel) -> Bool {
       return lhs.identifier == rhs.identifier
    }
}
