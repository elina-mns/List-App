//
//  CategoryViewController.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-17.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError()
        }
        navBar.backgroundColor = .white
        navBar.tintColor = .black
    }
    
    //MARK: - TableView Datasource functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //taps into the cell created on our superview
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let category = categories?[indexPath.row] else { fatalError("No category is found") }
        cell.textLabel?.text = category.name

        guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColor, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue to the ToDoListVC
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New category item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text ?? ""
            let randomColor = UIColor.init(randomColorIn: [UIColor.init(named: "color1")!, UIColor.init(named: "color2")!, UIColor.init(named: "color3")!, UIColor.init(named: "color4")!])
            newCategory.color = randomColor?.hexValue() ?? ""
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - TableView Manipulation functions
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        //fetch objects from Realm database
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Section: Delete from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
}


