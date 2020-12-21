//
//  Category.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-18.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let itemsList = List<Item>()
    
}
