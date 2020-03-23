//
//  SourcesViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/20/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var selectedNewsSourcesList = [NewsSource]()
    var fetchedTopic = [String]()
    var selectedSources: [NewsSource : Bool] = [:]
    
    var allSourcesArray = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sources"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes  = textAttributes
        self.navigationController?.navigationBar.tintColor = GNUIConfiguration.textColor
        view.backgroundColor = .white
        setupTableView()
        
    }
    
    func fetchNewsSources() {
        selectedNewsSourcesList.removeAll()
        fetchedTopic.removeAll()
        selectedSources = UserDefaults.standard.object([NewsSource:Bool].self, with: GNKeyConfiguration.selectedSourcesFetch) ?? [:]
        let selectedTopics = UserDefaults.standard.object(forKey: GNKeyConfiguration.topicFetchKey) as? [String] ?? []
        for source in selectedSources.keys {
            selectedNewsSourcesList.append(source)
        }
        
        for topic in selectedTopics {
            fetchedTopic.append(topic)
        }
        
        let newsSources = Channel(sectionType: .NewsSources, sites: selectedNewsSourcesList, topics: [])
        let topicsSources = Channel(sectionType: .Topics, sites: [], topics: fetchedTopic)
        
        allSourcesArray = [newsSources, topicsSources]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
           
        view.addSubview(tableView)
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.register(ChannelCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
            
              
        tableView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 750)
        bottomConstraint.isActive = true
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNewsSources()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allSourcesArray[section].sectionType == .NewsSources {
            return allSourcesArray[section].sites.count
        }else {
            return allSourcesArray[section].topics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChannelCell
        cell.selectionStyle = .none
        let source = allSourcesArray[indexPath.section]
            
        if source.sectionType == .NewsSources {
            let siteName = source.sites[indexPath.row].name
            let firstAlphabet = String(siteName.first ?? "A").uppercased()
            cell.alphabetLabel.text = firstAlphabet
            cell.sourcesLabel.text = siteName
        }else {
            let topicName = source.topics[indexPath.row]
            let firstAlphabet = String(topicName.first ?? "A").uppercased()
            cell.alphabetLabel.text = firstAlphabet
            cell.sourcesLabel.text = topicName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        view.addSubview(label)
        label.frame = CGRect(x: 12, y: 6, width: 200 , height: 30)
        label.textColor = .red
        view.backgroundColor = .white
        
        if section == 0 {
            label.text = "NEWS SITES"
        }else {
            label.text = "TOPICS"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfollowAction = UIContextualAction(style: .destructive, title: "Unfollow") { [weak self] (action, view, completion) in
            
            guard let strongself = self else { return }
            strongself.removeData(indexPath: indexPath)
            completion(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [unfollowAction])
        
      
        return swipeActionConfig
    }
    

    func removeData(indexPath: IndexPath) {
        let sourcesSection = self.allSourcesArray[indexPath.section]
           
           if sourcesSection.sectionType == .Topics {
               self.allSourcesArray[indexPath.section].topics.remove(at: indexPath.row)
               self.tableView.deleteRows(at: [indexPath], with: .fade)
               let updatedTopicsSection = self.allSourcesArray[indexPath.section].topics
               UserDefaults.standard.set(updatedTopicsSection, forKey: GNKeyConfiguration.topicFetchKey)
               
              
           }else {
               let removedSource = self.allSourcesArray[indexPath.section].sites.remove(at: indexPath.row)
            
               let remainingSites = self.allSourcesArray[indexPath.section].sites
            
                if remainingSites.count == 0 {
                    UserDefaults.standard.set(false, forKey: GNKeyConfiguration.onboardingStatus)
                }
               
               self.tableView.deleteRows(at: [indexPath], with: .fade)
               self.selectedSources[removedSource] = nil
               UserDefaults.standard.set(object: self.selectedSources, forKey: GNKeyConfiguration.selectedSourcesFetch)
           }
        NotificationCenter.default.post(name: .onboardingStatusNotification, object: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourcesSection = self.allSourcesArray[indexPath.section]
        
        if sourcesSection.sectionType == .Topics {
            let topicSelected = self.allSourcesArray[indexPath.section].topics[indexPath.row]
            let detailTopicViewController = SeeAllTopicalArticlesViewController()
            detailTopicViewController.topic = topicSelected
            detailTopicViewController.title = topicSelected
            self.navigationController?.pushViewController(detailTopicViewController, animated: true)
        }
    }
}
