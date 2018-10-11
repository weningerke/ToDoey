//
//  ViewController.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 01..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    //MARK: selectedCategory
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    
    // Megszámolja hogy mennyi sorra van szükség és létrehozza azt
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
        
//      Ternary operator ==»
//      value = condition ? valueIfTrue : valueIfFalse
//      cell.accessoryType = item.done == true ? .checkmark : .none
        
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    // Kiirattuk a tábla tartalmát a Debug konzolra
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        //MARK: pipa kezelése
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)
                }
            }catch{
                print("Error saveing done status, \(error)")
            }
        }

        tableView.reloadData()
        
    // animáltuk a kattintást
        tableView.deselectRow(at: indexPath, animated: true)
       
    }

    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in}
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new items")
                }
            }
            self.tableView.reloadData()
        
        }
        alert.addAction(action)
        
        alert.addAction(cancel)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // ?
        self.present(alert, animated: true, completion: nil)
    
}
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }

}

    //MARK: - SearchBar Method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
















