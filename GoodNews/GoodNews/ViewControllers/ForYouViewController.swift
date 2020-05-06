//
//  ViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/13/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class ForYouViewController: UIViewController, UICollectionViewDelegate, SectionFooterDelegate {

    //MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<ForYouSection, Article>?
    var snapshot = NSDiffableDataSourceSnapshot<ForYouSection, Article>()
    
    let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = GNUIConfiguration.mainForegroundColor
        button.setTitle("Get Started", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleGetStartedButton), for: .touchUpInside)
        return button
    }()
    
    let descriptionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.text = "Create your news feed by adding your own news source or topic"
        return label
    }()
    
    let newspaperImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .red
        imageView.image = UIImage(named: "newspapericon")
        return imageView
    }()
    
    private lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = GNUIConfiguration.mainForegroundColor
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    
    
    let networkManager = NewsNetworkManager()
    var onboardingStatus : Bool = false
    var onboardingViews: [UIView] = []
    var glideManager : Glide!
    var collectionView : UICollectionView!
    var fetchedSections : [ForYouSection] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "For You"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes  = textAttributes
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(handleSourceSelector))
        self.navigationItem.rightBarButtonItem?.tintColor = GNUIConfiguration.textColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.register(FeaturedArticleCell.self, forCellWithReuseIdentifier: FeaturedArticleCell.reuseIdentifier)
        collectionView.register(MiscArticleCell.self, forCellWithReuseIdentifier: MiscArticleCell.reuseIdentifier)
        collectionView.register(TopicalCell.self, forCellWithReuseIdentifier: TopicalCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(SectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooter.reuseIdentifier)
       
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        setupUIRefreshControl(with: collectionView)
        addNotificationObserver()
        onboardingFlowUpdate()
        
    }

    func loadData() {
        activityIndicator.startAnimating()
        let selectedSources = UserDefaults.standard.object([NewsSource : Bool].self, with: GNKeyConfiguration.selectedSourcesFetch)
        guard let selected = selectedSources else { return }
        let fetchedDomains = UserDefaults.standard.object(forKey: GNKeyConfiguration.domainFetchKey) as? [String]
    
        networkManager.fetchForYouArticles(sources: selected, domains: fetchedDomains) { (sections) in
            self.fetchedSections = sections
            DispatchQueue.main.async {
                self.createDataSource()
                self.reloadData()
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
    

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ForYouSection, Article>(collectionView: collectionView) { collectionView, indexPath, article in
            switch self.fetchedSections[indexPath.section].section {
            case .featured:
                return self.configure(FeaturedArticleCell.self, with: article, for: indexPath)
            case .misc:
                return self.configure(MiscArticleCell.self, with: article, for: indexPath)
            case .topical:
               return self.configure(TopicalCell.self, with: article, for: indexPath)
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
            if (kind == UICollectionView.elementKindSectionHeader) {
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                        return nil
                }

                guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
                if section.fetchSectionTitle() == nil { return nil }
                sectionHeader.title.text = section.fetchSectionTitle()
                sectionHeader.subtitle.text = section.fetchSectionSubtitles()
                
                return sectionHeader
            } else if (kind == UICollectionView.elementKindSectionFooter) {
                
                guard let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooter.reuseIdentifier, for: indexPath) as? SectionFooter else {
                        return nil
                }
                
                sectionFooter.delegate = self
                
                return sectionFooter
            }
            
            return nil
            
        }
    }
    
    func reloadData() {
        
        snapshot.appendSections(fetchedSections)

        for section in fetchedSections {
            snapshot.appendItems(section.articles, toSection: section)
        }

        dataSource?.apply(snapshot)
        activityIndicator.stopAnimating()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
    
            let section = self.fetchedSections[sectionIndex]

            switch section.section {
            case .featured:
                return self.createFeaturedSection(using: section)
            case .misc:
                return self.createMiscSection(using: section)
            case .topical:
                return self.createTopicalSection(using: section)
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
        subGroup2.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(550))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [subGroup1, subGroup2])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
    
        return layoutSection
    }
    
    func createMiscSection(using section: ForYouSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       // layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]


        return layoutSection
    }
    
    func createTopicalSection(using section: ForYouSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 0)
        
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .fractionalHeight(1))
        let layoutItem2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        layoutItem2.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 0)
        
        let subGroup1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
        let subGroup1 = NSCollectionLayoutGroup.horizontal(layoutSize: subGroup1Size, subitems: [layoutItem])
        
        let subGroup2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
        let subGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: subGroup2Size, subitems: [layoutItem2])
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(440))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [subGroup1, subGroup2])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        let layoutSectionHeader = createSectionHeader()
        let layoutSectionFooter = createSectionFooter()
        
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader, layoutSectionFooter]

        return layoutSection

    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: -12)
        return layoutSectionHeader
    }
    
    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        layoutSectionFooter.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: -12)
        return layoutSectionFooter
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = fetchedSections[indexPath.section].articles
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
        let selectedSources = UserDefaults.standard.object([NewsSource : Bool].self, with: GNKeyConfiguration.selectedSourcesFetch)
        guard let selected = selectedSources else { return }
        let fetchedDomains = UserDefaults.standard.object(forKey: GNKeyConfiguration.domainFetchKey) as? [String]
        
        networkManager.fetchForYouArticles(sources: selected, domains: fetchedDomains) { (sections) in
            self.fetchedSections = sections
            DispatchQueue.main.async {
                
                self.snapshot.deleteAllItems()
                self.snapshot.appendSections(self.fetchedSections)
                for section in self.fetchedSections {
                    self.snapshot.appendItems(section.articles, toSection: section)
                }
                self.dataSource?.apply(self.snapshot, animatingDifferences: true)

                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onboardingFlowUpdate), name: .onboardingStatusNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateForYouContainer), name: .addTopicNotification, object: nil)
    }
    

///    REMOVE THE CURRENT VIEWS
///    ADD THE COLLECTIONVIEW WHICH WILL SHOWCASE ALL THE NEW ARTICLES FROM THE SOURCES SELECTED
    
    @objc func onboardingFlowUpdate() {
        onboardingStatus = (UserDefaults.standard.bool(forKey: GNKeyConfiguration.onboardingStatus))
      
        if onboardingStatus {
        
               for view in self.onboardingViews {
                   view.removeFromSuperview()
                }
               self.view.addSubview(self.collectionView)
               activityIndicator.frame = CGRect(x: (self.view.frame.width / 2), y: 140, width: 10, height: 10)
               self.collectionView.addSubview(activityIndicator)
               self.setupNewsSourceCardController()
               self.view.layoutIfNeeded()
               
            if dataSource == nil {
                 loadData()
            }else {
                ///Data source is already present just refresh the data
                newsSourcesDidGetUpdated()
            }
               
            
         }else {
            fetchedSections.removeAll()
            view.backgroundColor = .white
            setupOnboardingViews()
            layoutViews()
            setupNewsSourceCardController()
            collectionView.removeFromSuperview()
            view.layoutIfNeeded()
         }
    }
    
    @objc func newsSourcesDidGetUpdated() {
        self.handleRefresh()
    }
    
    @objc func updateForYouContainer() {
        handleRefresh()
    }
    
    func setupNewsSourceCardController() {
        let selectNewsSourceController = SelectNewsSourcesViewController()
        let cardController = CardNavigationViewController(rootViewController: selectNewsSourceController)
        let glideConfig = Configuration()
        glideManager = Glide(parentViewController: self, configuration: glideConfig, card: cardController)
        selectNewsSourceController.glideManager = glideManager
        
    }
    //MARK: - Handlers
    @objc func handleGetStartedButton() {
        glideManager.triggerCard()
    }
    
    @objc func handleSourceSelector() {
        glideManager.triggerCard()
    }
    
    //MARK: - LayoutViews
    
    func setupOnboardingViews() {
        view.addSubview(newspaperImage)
        view.addSubview(descriptionText)
        view.addSubview(getStartedButton)
        onboardingViews = [newspaperImage, descriptionText, getStartedButton]
    }

    func layoutViews() {
        newspaperImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -125).isActive = true
        newspaperImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        newspaperImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: newspaperImage.bottomAnchor, constant: 10).isActive = true
        descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        getStartedButton.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 60).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        getStartedButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    func didTapButton() {
        let sourcesVC = SourcesViewController()
        self.navigationController?.pushViewController(sourcesVC, animated: true)
    }
    
    

}

