//
//  SectionHeader.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/18/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"

       let title = UILabel()
       let subtitle = UILabel()

       override init(frame: CGRect) {
           super.init(frame: frame)

           let separator = UIView(frame: .zero)
           separator.translatesAutoresizingMaskIntoConstraints = false
           separator.backgroundColor = .quaternaryLabel

           title.textColor = .red
           title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .bold))
           subtitle.textColor = .secondaryLabel
            subtitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .medium))

           let stackView = UIStackView(arrangedSubviews: [separator, title, subtitle])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           addSubview(stackView)

           NSLayoutConstraint.activate([
               separator.heightAnchor.constraint(equalToConstant: 1),

               stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
               stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
               stackView.topAnchor.constraint(equalTo: topAnchor),
               stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
           ])

           stackView.setCustomSpacing(10, after: separator)
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("Stop trying to make storyboards happen.")
       }
}

