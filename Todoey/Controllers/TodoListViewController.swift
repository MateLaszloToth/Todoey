//
//  ViewController.swift
//  Todoey
//
//  Created by Mate Toth on 12/20/18.
//  Copyright © 2018 Mate Toth. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // file path to create a plist(save defaults there)
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
   }
   
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.isDone = !item.isDone
                }
            }catch{
                print("Error updating row \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this will happen when the user clicks the Add Item button on UIAlert
            
            if let currentCategory = self.selectedCategory{
                do{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    
                    try self.realm.write {
                        
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(cancel)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulate Methods

    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

    //MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
}

