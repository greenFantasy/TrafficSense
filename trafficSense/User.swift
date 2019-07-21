//
//  User.swift
//  trafficSense
//
//  Created by Yousef Ahmed on 7/21/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var highScore = 0
    @objc dynamic var level = 1
    @objc dynamic var created = Date()
}
