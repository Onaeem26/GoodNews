//
//  DetailArticleWebViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/18/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit
import WebKit

class DetailArticleWebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    var article: Article? = nil
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let urlstring = article?.url
        guard let urlString = urlstring else { return }
        guard let url = URL(string: urlString) else {
            print("No URL FOUND FOR THIS ARTICLE")
            return
            
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.navigationController?.navigationBar.tintColor = GNUIConfiguration.textColor
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBackButton))
        self.navigationItem.rightBarButtonItem = refresh
        self.navigationItem.leftBarButtonItem = doneButton
        
        self.navigationItem.setHidesBackButton(true, animated: false)
   
        progressView = UIProgressView(progressViewStyle: .default)
        let navBarHeight = navigationController?.navigationBar.frame.height
        let navBarWidth = navigationController?.navigationBar.frame.width
        progressView.frame = CGRect(x: 0, y: navBarHeight ?? 0, width: navBarWidth ?? 0, height: 10)
           
        self.navigationController?.navigationBar.addSubview(progressView)
        
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webView.scrollView.delegate = self
        navigationController?.isToolbarHidden = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        self.progressView.isHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if progressView.progress == 1 {
                progressView.isHidden = true
            }else {
                progressView.isHidden = false
            }
            
        }
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
