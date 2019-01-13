//
//  Category.swift
//  Todoey
//
//  Created by Mate Toth on 1/4/19.
//  Copyright © 2019 Mate Toth. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
