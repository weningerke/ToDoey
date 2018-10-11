//
//  Items.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 09..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
