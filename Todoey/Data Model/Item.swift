//
//  Item.swift
//  Todoey
//
//  Created by Mate Toth on 1/4/19.
//  Copyright © 2019 Mate Toth. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
