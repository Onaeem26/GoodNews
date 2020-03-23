//
//  SelectNewsSourcesViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit


class SelectNewsSourcesViewController: UIViewController {

    let titleText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Select Source"
        titleText.font = titleText.font.withSize(24)
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let descriptionText : UILabel = {
        let titleText = UILabel()
        titleText.text = "You can get news from a specific news source or get news from a particular category or a topic"
        titleText.font = titleText.font.withSize(12)
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let topicButton: UIButton = {
         let button = UIButton(type: .system)
         button.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
         button.setTitle("Topic", for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitleColor(GNUIConfiguration.textColor, for: .normal)
         button.layer.cornerRadius = 20
         button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
         button.addTarget(self, action: #selector(handleTopicButton), for: .touchUpInside)
         return button
     }()
    
    let newsSourceButton: UIButton = {
         let button = UIButton(type: .system)
         button.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
         button.setTitle("News Source", for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
         button.setTitleColor(GNUIConfiguration.textColor, for: .normal)
         button.layer.cornerRadius = 20
         button.addTarget(self, action: #selector(handleNewsSourceButton), for: .touchUpInside)
         return button
     }()
    
    weak var glideManager : Glide?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        transparentNavigationBar()
        setupViews()
        layoutViews()
        
    }
    
    
    @objc func handleTopicButton() {
        guard let manager = glideManager else { return }
        let selectTopicVC = SelectTopicViewController()
        selectTopicVC.glideManager = manager
        self.navigationController?.pushViewController(selectTopicVC, animated: true)
        
        
    }
    
    @objc func handleNewsSourceButton() {
        guard let manager = glideManager else { return }
        let selectSourceVC = SelectSourceViewController()
        
        //delegate?.didUpdateSourcesList()
        selectSourceVC.glideManager = manager
        self.navigationController?.pushViewController(selectSourceVC, animated: true)
    }
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "", style: .plain, target: nil, action: nil)
       
    }
    func setupViews() {
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        view.addSubview(topicButton)
        view.addSubview(newsSourceButton)
    }
    
    func layoutViews() {
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleText.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 12).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -35).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        topicButton.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 20).isActive = true
        topicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topicButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        topicButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        newsSourceButton.topAnchor.constraint(equalTo: topicButton.bottomAnchor, constant: 12).isActive = true
        newsSourceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsSourceButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        newsSourceButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

