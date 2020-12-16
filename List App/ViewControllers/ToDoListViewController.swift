//
//  ToDoListViewController.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-15.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        items.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "Buy Eggos"
        items.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "Destroy Demogorgon"
        items.append(newItem3)
        
        if let itemsArray = defaults.array(forKey: "List Array") as? [Item] {
            items = itemsArray
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let itemArray = items[indexPath.row]
        cell.textLabel?.text = itemArray.title
        
        cell.accessoryType = itemArray.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        items[indexPath.row].done = !items[indexPath.row].done
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New list item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.items.append(newItem)
            self.defaults.setValue(self.items, forKey: "ListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

