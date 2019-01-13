//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mate Toth on 12/26/18.
//  Copyright © 2018 Mate Toth. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories are added yet."
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error adding object to realm \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
       
        categoryArray = realm.objects(Category.self)
       
        tableView.reloadData()
    }

    
}
