//
//  NewsNetworkManager.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/15/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class NewsNetworkManager: NewsNetworkManagerProtocol {
 
    func fetchNewsSources(completion: @escaping ([NewsSource]) -> ()) {
        guard let url = URL(string: "http://newsapi.org/v2/sources?apiKey=\(NetworkProperties.APIKEY)") else {
                     fatalError()
                 }
                 let urlRequest = URLRequest(url: url)
                 URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                     guard let data = data else { return }
                     do {
                         let sourcesList = try JSONDecoder().decode(Source.self, from: data)
                        completion(sourcesList.sources)
                     } catch {
                         print(error)
                     }
                         
            }.resume()
    }
    
    func fetchArticles(sources: [NewsSource : Bool], completion: @escaping ([ForYouSection]) -> ()) {
        var sourcesArray: [String] = []
        
        print("Sources Key", sources.keys.count)
        for source in sources.keys {
            sourcesArray.append(source.id)
        }
        
        //Fetched Sources Articles
        var fetchedArticles: [Article] = []
        var totalForYouArticles = [ForYouSection]()
        let joinedSourcesRequest = sourcesArray.joined(separator: ",")
        
            guard let url = URL(string: "http://newsapi.org/v2/top-headlines?sources=\(joinedSourcesRequest)&apiKey=\(NetworkProperties.APIKEY)") else {
                fatalError()
            }
            let urlRequest = URLRequest(url: url)
              URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    guard let data = data else { return }
                do {
                     let sourcesList = try JSONDecoder().decode(ArticleList.self, from: data)
                    
                    fetchedArticles.append(contentsOf: sourcesList.articles)
                    
                    if fetchedArticles.count > 3 {
                        // First 3 will be shown as the featured
                        // Remaining articles will be shown normally
                        
                        let featuredArticles = Array(fetchedArticles[0..<3])
                        let remainingArticles = Array(fetchedArticles[3...])
                        
                        let forYouArticles = ForYouSection(section: .featured, articles: featuredArticles)
                        let miscArticles = ForYouSection(section: .misc, articles: remainingArticles)
                          
                            
                        totalForYouArticles.append(forYouArticles)
                        totalForYouArticles.append(miscArticles)
                        
                        completion(totalForYouArticles)
                    }else {
                        
                        completion([ForYouSection(section: .featured, articles: fetchedArticles)])
                    }
                } catch {
                    print(error)
                }
                         
            }.resume()
        
    }
    
    func fetchTopicalArticles(topics: [String], completion: @escaping (ForYouSection) -> ()) {
        let topicArticles = topics.joined(separator: "+")
            guard let url = URL(string: "http://newsapi.org/v2/everything?q=\(topicArticles)&pageSize=20&sortBy=popularityr&apiKey=\(NetworkProperties.APIKEY)") else {

                   return
               }
                        let urlRequest = URLRequest(url: url)
                        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                            guard let data = data else { return }
                            do {
                                let articles = try JSONDecoder().decode(ArticleList.self, from: data)
                                let topicArticles = articles.articles
                                
                                    let fetchedArticles = ForYouSection(section: .topical, articles: topicArticles)
                                    completion(fetchedArticles)
                                
                                
                            } catch {
                                print(error)
                            }
                                
                   }.resume()
   
    }
    
    
    func fetchForYouArticles(sources: [NewsSource : Bool], domains: [String]?, completion: @escaping ([ForYouSection]) -> ()) {
        var fetchedArticles : [ForYouSection] = []
        var fetchedTopicalArray = domains ?? []
        self.fetchArticles(sources: sources) { [weak self] (sections) in
            fetchedArticles = sections
            
            guard let strongSelf = self else {
                print("No Strong Self")
                return
                
            }
            
            if fetchedTopicalArray.count > 0 {
                    
                strongSelf.fetchDomainArticles(domains: fetchedTopicalArray, page: 1) { (domains) in
                    // fetchedTopicalArticles = topicSections
                    //Changing order of the data source
                    if fetchedArticles.count == 2 {
                        let featuredArticles = fetchedArticles[0]
                        let miscArticles = fetchedArticles[1]
                        let allArticles =  [featuredArticles, domains, miscArticles]

                        completion(allArticles)
                    }else {
                        let featuredArticles = fetchedArticles[0]
                        let allArticles =  [featuredArticles, domains]
                        completion(allArticles)
                    }
                }
                             
            }else {
                completion(fetchedArticles)
            }

        }
    }
    
    func fetchDomainArticles(domains: [String], page: Int, completion: @escaping (ForYouSection) -> ()) {
         let domainJoined = domains.joined(separator: ",")
         guard let url = URL(string: "https://newsapi.org/v2/everything?domains=\(domainJoined)&page=\(page)&apiKey=\(NetworkProperties.APIKEY)") else {

                return
            }
                     let urlRequest = URLRequest(url: url)
                     URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                         guard let data = data else { return }
                         do {
                             let articles = try JSONDecoder().decode(ArticleList.self, from: data)
                             let topicArticles = articles.articles
                             
                                 let fetchedArticles = ForYouSection(section: .topical, articles: topicArticles)
                                 completion(fetchedArticles)
                             
                             
                         } catch {
                             print(error)
                         }
                             
                }.resume()
     }
}
