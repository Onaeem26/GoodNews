//
//  NewsNetworkManagerProtocol.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/15/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

protocol NewsNetworkManagerProtocol {
    func fetchNewsSources(completion: @escaping ([NewsSource]) -> ())
    func fetchArticles(sources: [NewsSource: Bool], completion: @escaping ([ForYouSection]) -> ())
    func fetchTopicalArticles(topics: [String], completion: @escaping (ForYouSection) -> ())
    func fetchForYouArticles(sources: [NewsSource: Bool], domains: [String]?, completion: @escaping ([ForYouSection]) -> ())
    func fetchDomainArticles(domains: [String], page: Int, completion: @escaping (ForYouSection) -> ())
}

