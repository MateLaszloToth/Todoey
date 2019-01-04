//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mate Toth on 12/26/18.
//  Copyright © 2018 Mate Toth. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
            
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            self.saveCategories()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        if context.hasChanges{
            do{
                try context.save()
            } catch{
                print("Error saving category context: \(error)")
            }
            tableView.reloadData()
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading category context: \(error)")
        }
        tableView.reloadData()
    }
    
    
}
