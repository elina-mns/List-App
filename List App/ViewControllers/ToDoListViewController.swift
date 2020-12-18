//
//  ToDoListViewController.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-15.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //MARK: - Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        if let itemArray = items?[indexPath.row] {
            cell.textLabel?.text = itemArray.title
            cell.accessoryType = itemArray.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // the order of these steps below are important for the correct removal of items
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        
//        items[indexPath.row].done = !items[indexPath.row].done
//        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New list item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.itemsList.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        items = selectedCategory?.itemsList.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Search Bar Functions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //filter the results of search bar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort the results of search bar
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, using: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems() //fetches all of the items from the persistent store
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

