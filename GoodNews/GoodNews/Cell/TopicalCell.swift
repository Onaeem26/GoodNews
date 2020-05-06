//
//  TopicalCell.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/18/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class TopicalCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "TopicalCell"
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    let backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.alpha = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let articleName: UILabel = {
       let label = UILabel()
        label.text = "This is some sort of a headline"
        //label.backgroundColor = .red
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articlePublishedDate: UILabel = {
        let label = UILabel()
        label.text = "2 hours ago"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        addSubview(backgroundImageView)
        addSubview(articleName)
       // addSubview(articlePublishedDate)
    }
    
    override func prepareForReuse() {
        self.backgroundImageView.image = nil
        self.backgroundImageView.cancelImageLoad()
    }
    
    func layoutViews() {
        bringSubviewToFront(articleName)
        backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
//        articlePublishedDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18).isActive = true
//        articlePublishedDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
//        articlePublishedDate.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        articlePublishedDate.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        articleName.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 8).isActive = true
        articleName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        articleName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12).isActive = true
        articleName.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with article: Article) {
        articleName.text = article.title
        backgroundImageView.loadImage(at: article.urlToImage ?? "")
    }

}
