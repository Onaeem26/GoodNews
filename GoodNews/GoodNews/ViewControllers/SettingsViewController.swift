//
//  SettingsViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var reuseIdentifier = "SettingsTableCellID"
    
    let data = [Setting(title: "Twitter - @madebyon", link: "https://www.twitter.com/madebyon"),
                Setting(title: "Github - @onaeem26", link: "https://www.github.com/onaeem26"),
                Setting(title: "Blog - ExploringSwift", link: "https://exploringswift.com")
    
    
    ]
    
    let newspaperImage: UIImageView = {
          let imageView = UIImageView()
          imageView.translatesAutoresizingMaskIntoConstraints = false
          //imageView.backgroundColor = .red
          imageView.image = UIImage(named: "newspapericon1")
          return imageView
      }()
    
    let titleText: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.textAlignment = .center
         label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
         label.text = "GoodNews"
         return label
     }()
    
    let descriptionText: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 0
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
           label.text = "V1.2"
           return label
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
        configureViews()
    }
    
    func configureViews() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        self.view.backgroundColor = tableView.backgroundColor
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        view.addSubview(newspaperImage)
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        
        titleText.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -250).isActive = true
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        newspaperImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        newspaperImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        newspaperImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = data[indexPath.row].link
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
