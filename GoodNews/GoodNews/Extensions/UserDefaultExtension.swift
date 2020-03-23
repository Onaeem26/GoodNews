//
//  Extension.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/16/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import Foundation

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}

extension Notification.Name {
     static let onboardingStatusNotification = Notification.Name("onboardingStatusNotification")
     static let addTopicNotification = Notification.Name("AddTopicNotification")
}
