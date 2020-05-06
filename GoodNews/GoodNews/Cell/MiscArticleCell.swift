//
//  MiscArticleCell.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/17/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class MiscArticleCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "MiscArticleID"
    
    let thumbnailImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let articleName: UILabel = {
        let label = UILabel()
         label.text = "This is some sort of a headline"
         //   label.backgroundColor = .yellow
         label.textColor = .black
         label.font = UIFont.boldSystemFont(ofSize: 16)
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    let articleDescription: UILabel = {
        let label = UILabel()
         label.text = "This is some sort of a description"
         //label.backgroundColor = .yellow
         label.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
         label.font = UIFont.boldSystemFont(ofSize: 11)
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    let articleSource: UILabel = {
        let label = UILabel()
        label.text = "2 hours ago"
        //label.backgroundColor = .red
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articlePublishedDate: UILabel = {
         let label = UILabel()
         label.text = "2 hours ago"
         //label.backgroundColor = .red
         label.textColor = .gray
         label.font = UIFont.systemFont(ofSize: 9)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white//UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        setupViews()
        layoutViews()
    }
    
    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
        self.thumbnailImageView.cancelImageLoad()
        
    }
    
    func configure(with article: Article) {
        thumbnailImageView.loadImage(at: article.urlToImage ?? "")
        articleName.text = article.title
        articleDescription.text = article.description
        articleSource.text = article.source["name"] ?? "Source not available"
        articlePublishedDate.text = Date().getElapsedInterval(date: article.publishedAt ?? "")
        
    }
    

    func setupViews() {
        addSubview(thumbnailImageView)
    }
    

    
    func layoutViews() {
        bringSubviewToFront(articleName)
        bringSubviewToFront(articleDescription)
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [articleSource, articleName, articlePublishedDate])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
       stackView.setCustomSpacing(4, after: articlePublishedDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
