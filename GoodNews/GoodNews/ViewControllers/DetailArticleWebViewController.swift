//
//  DetailArticleWebViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/18/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit
import WebKit

class DetailArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var article: Article? = nil
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlstring = article?.url
        guard let urlString = urlstring else { return }
        guard let url = URL(string: urlString) else {
            print("No URL FOUND FOR THIS ARTICLE")
            return
            
        }
        webView.load(URLRequest(url: url))
        self.navigationController?.navigationBar.tintColor = GNUIConfiguration.textColor
        
          
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
      //  navigationController?.isToolbarHidden = false
       // self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
}
