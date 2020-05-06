//
//  Articles.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/16/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

struct Article: Decodable, Hashable {
    let title: String?
    let description: String?
    let publishedAt: String?
    let url: String?
    let urlToImage: String?
    let source: [String: String?]
}

struct ArticleList : Decodable {
    var articles : [Article]
}


enum Section {
    case featured
    case topical
    case misc
}

struct ForYouSection: Hashable {
    let  identifier: UUID = UUID() 
    let  section: Section
    var  articles: [Article]
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    func fetchSectionTitle() -> String? {
        switch self.section {
        case .featured:
            return "Top Stories"
        case .misc:
            return "Top Headlines"
        case .topical:
            return "Chosen Websites"
            
        }
    }
    
    func fetchSectionSubtitles() -> String? {
        switch self.section {
        case .featured:
         let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: Date())
        case .misc:
            return "Perfectly curated top stories from your selections"
        case .topical:
            return "Latest from your added domains"
            
        }
    }

    static func == (lhs: ForYouSection, rhs: ForYouSection) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.articles == rhs.articles && lhs.section == rhs.section
     }
     
}
