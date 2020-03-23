//
//  ChannelCell.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/22/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class ChannelCell : UITableViewCell {
    
    let sourcesLabel : UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello"
        return label
    }()
    
    let alphabetLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = [GNUIConfiguration.selectedColor, GNUIConfiguration.mainForegroundColor, GNUIConfiguration.secondaryForegroundColor].randomElement()
        label.textAlignment =  .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = "H"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(sourcesLabel)
        addSubview(alphabetLabel)
    }
    func layoutViews() {
        
        alphabetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        alphabetLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        alphabetLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        alphabetLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        sourcesLabel.leftAnchor.constraint(equalTo: alphabetLabel.rightAnchor, constant: 8).isActive = true
        sourcesLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5).isActive = true
        sourcesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.5).isActive = true
        sourcesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
