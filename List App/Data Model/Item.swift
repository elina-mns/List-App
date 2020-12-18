//
//  Item.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-18.
//

import Foundation
import RealmSwift

class Item: Object {
    
    //dynamic let us monitor changes and update them
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    //defining the relationship between items, it is important to specify the property's exact name
    var parentCategory = LinkingObjects(fromType: Category.self, property: "itemsList")
    
}
