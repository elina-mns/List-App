//
//  Item.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-18.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    //defining the relationship between items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "itemsList")
}
