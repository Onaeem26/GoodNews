//
//  SelectDomainViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 5/3/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SelectDomainViewController: UIViewController {

    let titleText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Add Domain"
        titleText.textColor = .label
        titleText.font = titleText.font.withSize(24)
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let descriptionText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Add any specific domain you wish to get news from:"
        titleText.font = titleText.font.withSize(12)
        titleText.textColor = .secondaryLabel
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let errorTextLabel : UILabel = {
        let titleText = UILabel()
        titleText.text = "Invalid URL"
        titleText.font = titleText.font.withSize(12)
        titleText.textColor = .systemRed
        titleText.isHidden = true
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .left
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    lazy var domainTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "9to5mac.com"
        textfield.delegate = self
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let addDomainButton: UIButton = {
         let button = UIButton(type: .system)
         button.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
         button.setTitle("Add Domain", for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
         button.setTitleColor(GNUIConfiguration.textColor, for: .normal)
         button.layer.cornerRadius = 20
         button.addTarget(self, action: #selector(handleAddTopicButton), for: .touchUpInside)
         return button
     }()
        
    weak var glideManager: Glide?
    var addedTopics: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupViews()
        layoutViews()
        glideManager?.delegate = self
        
        self.navigationController?.navigationBar.tintColor = GNUIConfiguration.textColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismiss)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchedTopics = UserDefaults.standard.object(forKey: GNKeyConfiguration.domainFetchKey) as? [String]
        addedTopics = fetchedTopics ?? []
        print("Fetched:", fetchedTopics)
        print("Added Domains:", addedTopics)
    }
    
    @objc func handleKeyboardDismiss() {
        self.domainTextField.resignFirstResponder()
    }
    
    @objc func handleAddTopicButton() {
        if domainTextField.text!.isEmpty {
        }else {
            let input = domainTextField.text!
            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                if matches.count == 0 {
                    errorTextLabel.isHidden = false
                }
                for match in matches {
                    guard let range = Range(match.range, in: input) else { continue }
                    let detectedURL = input[range]
                    addedTopics.append(detectedURL.lowercased())
                    UserDefaults.standard.set(addedTopics, forKey: GNKeyConfiguration.domainFetchKey)
                    glideManager?.collapseCard()
                    NotificationCenter.default.post(name: .addTopicNotification, object: nil)
                    errorTextLabel.isHidden = true
                }
            }catch {
                print("Not Valid URL")
            }
        }
    }
    
    func setupViews() {
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        view.addSubview(domainTextField)
        view.addSubview(addDomainButton)
        view.addSubview(errorTextLabel)
    }
    
    
    func layoutViews() {
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleText.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 12).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -35).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        domainTextField.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 16).isActive = true
        domainTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        domainTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        domainTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        errorTextLabel.topAnchor.constraint(equalTo: domainTextField.bottomAnchor, constant: 4).isActive = true
        errorTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        errorTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -35).isActive = true
        errorTextLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        addDomainButton.topAnchor.constraint(equalTo: errorTextLabel.bottomAnchor, constant: 24).isActive = true
        addDomainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addDomainButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        addDomainButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

extension SelectDomainViewController : GlideDelegate {
    func glideDidClose() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func glideStateChangingFromOpenToCompress() {
        domainTextField.resignFirstResponder()
    }
}

extension SelectDomainViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let manager = glideManager else { return }
        manager.triggerOpenState()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        errorTextLabel.isHidden = true
    }

}
