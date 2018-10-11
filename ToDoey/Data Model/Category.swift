//
//  Category.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 09..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    // Létrehoz egy üres Item objektumokból sorozatot(array)
    // A List metod a Realm metódusa
    let items = List<Item>()
}
