//
//  SeeAllTopicalArticlesViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/22/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SeeAllTopicalArticlesViewController : UIViewController, UICollectionViewDelegate {
    
    var topic: String?  {
        didSet {
            loadTopicData()
        }
    }
    var domain: String?  {
        didSet {
            loadDomainData(page: self.page)
        }
    }
    let networkManager = NewsNetworkManager()
    var fetchedTopicArticles: [Article] = []
    var fetchedTopicSection: [ForYouSection] = []
    var collectionView : UICollectionView!
    var page: Int = 1
    
    var newDomainArticles: [Article] = []
    var dataSource: UICollectionViewDiffableDataSource<ForYouSection, Article>?
    var snapshot = NSDiffableDataSourceSnapshot<ForYouSection, Article>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.register(MiscArticleCell.self, forCellWithReuseIdentifier: MiscArticleCell.reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(self.collectionView)
        setupUIRefreshControl(with: collectionView)
      
        
    }
    
    func loadTopicData() {
        guard let topic = self.topic else { return }
        networkManager.fetchTopicalArticles(topics: [topic]) { [weak self] (section) in
            guard let strongSelf = self else { return }
            strongSelf.fetchedTopicSection = [section]
            strongSelf.fetchedTopicArticles = section.articles
            print(strongSelf.fetchedTopicArticles.count)
            DispatchQueue.main.async {
                strongSelf.createDataSource()
                strongSelf.reloadData()
            }
        }
    }
    
    func loadDomainData(page: Int) {
        guard let domain = self.domain else { return }
        networkManager.fetchDomainArticles(domains: [domain], page: page) { [weak self] (section) in
            guard let strongSelf = self else { return }
            if page > 1 {
                strongSelf.newDomainArticles.append(contentsOf: section.articles)
            }else {
                strongSelf.fetchedTopicSection = [section]
                strongSelf.newDomainArticles = section.articles
            }
            strongSelf.fetchedTopicArticles.append(contentsOf: section.articles)
            DispatchQueue.main.async {
                strongSelf.createDataSource()
                strongSelf.reloadData()
            }
        }
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with article: Article, for indexPath: IndexPath) -> T {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
             fatalError("Unable to dequeue \(cellType)")
         }
        if indexPath.row == newDomainArticles.count - 1 {
            page += 1
            loadDomainData(page: page)
        }
  
        cell.configure(with: article)

         return cell
     }
     
     func createDataSource() {
         dataSource = UICollectionViewDiffableDataSource<ForYouSection, Article>(collectionView: collectionView) { [weak self] collectionView, indexPath, article in
            guard let strongSelf = self else { return nil }
             switch strongSelf.fetchedTopicSection[indexPath.section].section {
            default:
                return strongSelf.configure(MiscArticleCell.self, with: article, for: indexPath)
            }
         }
     }
    

     func reloadData() {
 
        if page == 1 {
            snapshot.appendSections(fetchedTopicSection)
           for section in fetchedTopicSection {
              snapshot.appendItems(section.articles, toSection: section)
           }
            dataSource?.apply(snapshot)
            self.collectionView.refreshControl?.endRefreshing()
        }else {
            let lastItem = ((page - 1) * 20 - 1)
            let lowerboundIndex = (((page - 1) * 20))
            let upperBoundIndex = ((page * 20) - 1)
            let itemsToBeInserted = Array(newDomainArticles[lowerboundIndex...upperBoundIndex])
            snapshot.insertItems(itemsToBeInserted, afterItem: snapshot.itemIdentifiers[lastItem])
            
            dataSource?.apply((snapshot), animatingDifferences: false)
          }
     }
    
     func createCompositionalLayout() -> UICollectionViewLayout {
         let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
             guard let strongSelf = self else { return nil}
             let section = strongSelf.fetchedTopicSection[sectionIndex]

             switch section.section {
             default:
                return strongSelf.createMiscSection(using: section)
             }
         }

         let config = UICollectionViewCompositionalLayoutConfiguration()
         config.interSectionSpacing = 20
         layout.configuration = config
         return layout
     }
     
  
    
    func createMiscSection(using section: ForYouSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = newDomainArticles
        let destWebViewController = DetailArticleWebViewController()
        destWebViewController.article = section[indexPath.row]
        destWebViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destWebViewController, animated: true)
        
    
    }
    
    func setupUIRefreshControl(with collectionView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
       
        if let topic = self.topic {
            networkManager.fetchTopicalArticles(topics: [topic]) { [weak self] (section) in
                    guard let strongSelf = self else { return }
                    strongSelf.fetchedTopicSection = [section]
                    strongSelf.newDomainArticles = section.articles
                    DispatchQueue.main.async {
                        strongSelf.snapshot.deleteAllItems()
                        strongSelf.snapshot.appendSections(strongSelf.fetchedTopicSection)
                        for section in strongSelf.fetchedTopicSection {
                            strongSelf.snapshot.appendItems(section.articles, toSection: section)
                        }
                        strongSelf.dataSource?.apply(strongSelf.snapshot, animatingDifferences: true)

                        strongSelf.collectionView.refreshControl?.endRefreshing()
                    }
                }
        }else if let domain = self.domain {
            networkManager.fetchDomainArticles(domains: [domain], page: 1) { [weak self] (section) in
                  guard let strongSelf = self else { return }
                  strongSelf.fetchedTopicSection = [section]
                  strongSelf.newDomainArticles = section.articles
                  strongSelf.page = 1
                  DispatchQueue.main.async {
                      strongSelf.snapshot.deleteAllItems()
                      strongSelf.snapshot.appendSections(strongSelf.fetchedTopicSection)
                      for section in strongSelf.fetchedTopicSection {
                          strongSelf.snapshot.appendItems(section.articles, toSection: section)
                      }
                      strongSelf.dataSource?.apply(strongSelf.snapshot, animatingDifferences: true)
                      strongSelf.collectionView.refreshControl?.endRefreshing()
                  }
                }
            }
    }
    
    deinit {
        print("Deinitilaize data")
    }
}


