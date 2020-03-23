//
//  SelectSourceViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/14/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit
import Combine


class SelectSourceViewController: UIViewController {

    var networkManager = NewsNetworkManager()
    var selectedSources = [NewsSource: Bool]()
    var fetchedSources = [NewsSource: Bool]()
    
    let titleText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Select News Source"
        titleText.font = titleText.font.withSize(22)
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let descriptionText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Add any topic you wish to get news on, for eg: UEFA, Apple etc"
        titleText.font = titleText.font.withSize(12)
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "ABC News"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView = UITableView()
    let searchBarController = UISearchController(searchResultsController: nil)
    var filteredSources: [NewsSource] = []
    var dataSource : [NewsSource] = [] {
        didSet {
            print(self.dataSource.count)
        }
    }
    
    weak var glideManager: Glide?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
        glideManager?.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleAddButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationController?.navigationBar.tintColor = GNUIConfiguration.textColor
        self.tableView.rowHeight = 70
        setupTableView()
        fetchSources()
        setupSearchController()
        
    }
    
    
    
    func fetchSources() {
        
        networkManager.fetchNewsSources { (sources) in
            self.dataSource = sources
            self.filteredSources = sources
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchSelectedList() {
        fetchedSources = UserDefaults.standard.object([NewsSource:Bool].self, with: GNKeyConfiguration.selectedSourcesFetch) ?? [:]
        selectedSources = fetchedSources
    }
    
    @objc func handleAddButton() {
        print("Save the select data into userdefaults")
        guard let manager = glideManager else { return }
        UserDefaults.standard.set(object: selectedSources, forKey: GNKeyConfiguration.selectedSourcesFetch)
        if selectedSources.count == 0 {
            UserDefaults.standard.set(false, forKey: GNKeyConfiguration.onboardingStatus)
        }else {
            UserDefaults.standard.set(true, forKey: GNKeyConfiguration.onboardingStatus)
        }
        NotificationCenter.default.post(name: .onboardingStatusNotification, object: nil)
        manager.collapseCard()
    }
    
    
    
    func setupTableView() {
        
           view.addSubview(tableView)
           tableView.backgroundColor = .white
           tableView.dataSource = self
           tableView.delegate = self
           tableView.allowsSelection = true
           tableView.register(SourcesTableViewCell.self, forCellReuseIdentifier: "cell")
           tableView.translatesAutoresizingMaskIntoConstraints = false
           
           
           tableView.topAnchor.constraint(equalTo:  view.topAnchor, constant: 80).isActive = true
           tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
           tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
 //       tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
           let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           bottomConstraint.priority = UILayoutPriority(rawValue: 750)
           bottomConstraint.isActive = true
           
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.definesPresentationContext = true
        fetchSelectedList()
    }
  

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        glideManager?.shouldHandleGesture = true
    }

    
    func setupSearchController() {
        searchBarController.searchBar.placeholder = "Search News Sources"
        searchBarController.searchResultsUpdater = self
        searchBarController.delegate = self
        self.navigationItem.searchController = searchBarController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchBarController.dimsBackgroundDuringPresentation = false
        self.searchBarController.hidesNavigationBarDuringPresentation = false
        
    }
   
}

extension SelectSourceViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            if searchText.count == 0 {
                filteredSources = self.dataSource
            }
            else {
                filteredSources = self.dataSource.filter {
                    return $0.name.lowercased().contains(searchText)
                } ?? []
            }
        }
        self.tableView.reloadData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        guard let manager = glideManager else { return }
        manager.triggerOpenState()
     }

    func willDismissSearchController(_ searchController: UISearchController) {
        guard let manager = glideManager else { return }
        manager.shouldHandleGesture = true
    }
    
}



extension SelectSourceViewController: UITableViewDataSource, UITableViewDelegate {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !filteredSources.isEmpty ? filteredSources.count : 0
      }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SourcesTableViewCell
        cell.selectionStyle = .none
        let source = filteredSources[indexPath.row]
        
        cell.sourcesLabel.text = source.name
        cell.countryLabel.text = source.country
        cell.categoryLabel.text = source.category
        if let _ = (selectedSources[source]) {
            cell.selectedDot.isHidden = false
        }else {
            cell.selectedDot.isHidden = true
        }
        
        return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SourcesTableViewCell {
            let source = filteredSources[indexPath.row]
      
            if cell.selectedDot.isHidden {
                cell.selectedDot.isHidden = false
                selectedSources[source] = true
            }else {
                cell.selectedDot.isHidden = true
                selectedSources[source] = nil
            }
            
            if selectedSources.count > 0  {
                 self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else if selectedSources.count == 0 && fetchedSources.count > 0 {
                 self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else {
                 self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
 

}

extension SelectSourceViewController : GlideDelegate {
    func glideDidClose() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func glideStateChangingFromOpenToCompress() {
        self.searchBarController.isActive = false
    }
}



