//
//  SelectTopicViewController.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/14/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class SelectTopicViewController : UIViewController{
    
    let titleText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Add Topic"
        titleText.textColor = .label
        titleText.font = titleText.font.withSize(24)
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    let descriptionText : UILabel = {
        let titleText = UILabel()
        titleText.text = "Add any topic you wish to get news on, for eg: UEFA, Apple etc"
        titleText.font = titleText.font.withSize(12)
        titleText.textColor = .secondaryLabel
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .center
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    lazy var topicTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Apple"
        textfield.delegate = self
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let addTopicButton: UIButton = {
         let button = UIButton(type: .system)
         button.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
         button.setTitle("Add Topic", for: .normal)
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
        let fetchedTopics = UserDefaults.standard.object(forKey: GNKeyConfiguration.topicFetchKey) as? [String]
        addedTopics = fetchedTopics ?? []
        print("Fetched:", fetchedTopics)
        print("Added Topics:", addedTopics)
    }
    
    @objc func handleKeyboardDismiss() {
        self.topicTextField.resignFirstResponder()
    }
    
    @objc func handleAddTopicButton() {
        if topicTextField.text!.isEmpty {
            print("No topic to add")
        }else {
            addedTopics.append(topicTextField.text ?? "")
            UserDefaults.standard.set(addedTopics, forKey: GNKeyConfiguration.topicFetchKey)
            glideManager?.collapseCard()
            NotificationCenter.default.post(name: .addTopicNotification, object: nil)
           
        }
    }
    
    func setupViews() {
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        view.addSubview(topicTextField)
        view.addSubview(addTopicButton)
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
        
        topicTextField.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 16).isActive = true
        topicTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        topicTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        topicTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addTopicButton.topAnchor.constraint(equalTo: topicTextField.bottomAnchor, constant: 24).isActive = true
        addTopicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addTopicButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        addTopicButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

extension SelectTopicViewController : GlideDelegate {
    func glideDidClose() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func glideStateChangingFromOpenToCompress() {
        topicTextField.resignFirstResponder()
    }
    
    
}

extension SelectTopicViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let manager = glideManager else { return }
        manager.triggerOpenState()
        
    }

    
}
