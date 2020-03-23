//
//  SeeAllTopicalArticlesViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/22/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SeeAllTopicalArticlesViewController : UIViewController, UICollectionViewDelegate {
    
    var topic: String?
    let networkManager = NewsNetworkManager()
    var fetchedTopicArticles: [Article] = []
    var fetchedTopicSection: [ForYouSection] = []
    var collectionView : UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<ForYouSection, Article>?
    var snapshot = NSDiffableDataSourceSnapshot<ForYouSection, Article>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.register(FeaturedArticleCell.self, forCellWithReuseIdentifier: FeaturedArticleCell.reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(self.collectionView)
        setupUIRefreshControl(with: collectionView)
        loadData()
        
    }
    
    func loadData() {
        guard let topic = self.topic else { return }
        print("Show articles of the following topic: ", topic )
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
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with article: Article, for indexPath: IndexPath) -> T {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
             fatalError("Unable to dequeue \(cellType)")
         }

         cell.configure(with: article)
         return cell
     }
     
    // func configurHeadrer
     
     func createDataSource() {
         dataSource = UICollectionViewDiffableDataSource<ForYouSection, Article>(collectionView: collectionView) { collectionView, indexPath, article in
             switch self.fetchedTopicSection[indexPath.section].section {
             case .topical:
                return self.configure(FeaturedArticleCell.self, with: article, for: indexPath)
            default:
                return self.configure(FeaturedArticleCell.self, with: article, for: indexPath)
            }
         }
     }
     
     func reloadData() {
         
         snapshot.appendSections(fetchedTopicSection)

         for section in fetchedTopicSection {
             snapshot.appendItems(section.articles, toSection: section)
         }

         dataSource?.apply(snapshot)
     }
     
     func createCompositionalLayout() -> UICollectionViewLayout {
         let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
     
             let section = self.fetchedTopicSection[sectionIndex]

             switch section.section {
             case .topical:
                 return self.createFeaturedSection(using: section)
             default:
                return self.createFeaturedSection(using: section)
             }
         }

         let config = UICollectionViewCompositionalLayoutConfiguration()
         config.interSectionSpacing = 20
         layout.configuration = config
         return layout
     }
     
    
    func createFeaturedSection(using section: ForYouSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        
        
        let subGroup1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let subGroup1 = NSCollectionLayoutGroup.horizontal(layoutSize: subGroup1Size, subitems: [layoutItem])
        
        let subGroup2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let subGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: subGroup2Size, subitems: [layoutItem2])
        subGroup2.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(550))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [subGroup1, subGroup2])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
       // layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
//
//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
    
        return layoutSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Index Path Tapped", indexPath.row)
        let section = fetchedTopicSection[indexPath.section].articles
        print("Article",section[indexPath.row].title)
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
        guard let topic = self.topic else { return }
        networkManager.fetchTopicalArticles(topics: [topic]) { [weak self] (section) in
            guard let strongSelf = self else { return }
            strongSelf.fetchedTopicSection = [section]
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
