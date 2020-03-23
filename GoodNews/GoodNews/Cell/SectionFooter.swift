//
//  SectionFooter.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/21/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit
protocol SectionFooterDelegate {
    func didTapButton()
}

class SectionFooter: UICollectionReusableView {
    static let reuseIdentifier = "FooterHeader"

        let button = UIButton(type: .system)
        var delegate: SectionFooterDelegate?

       override init(frame: CGRect) {
        super.init(frame: frame)

        
        button.setTitle("See All Topics", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(handleSeeAllTopicsbutton), for: .touchUpInside)
        button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .medium))
        

        let stackView = UIStackView(arrangedSubviews: [button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        addSubview(stackView)

        NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

}
    
    @objc func handleSeeAllTopicsbutton() {
        delegate?.didTapButton()
    }

       required init?(coder aDecoder: NSCoder) {
           fatalError("Stop trying to make storyboards happen.")
       }
}

