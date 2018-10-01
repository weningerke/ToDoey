//
//  ViewController.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 01..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = ["vmi"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }

    }
    
    //Mark - Tableview Datasource Methods
    // Megszámolja hogy mennyi sorra van szükség és létrehozza azt
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    //Mark - TableView Delegate Methods
    // Kiirattuk a tábla tartalmát a Debug konzolra
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print(itemArray[indexPath.row])

    //pipa kezelése
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
    // animáltuk a kattintást
        tableView.deselectRow(at: indexPath, animated: true)
       
    }

        // Mark - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user click the Add Item button our UIAlert
            //print(textField.text)
            
            
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        // ?
        present(alert, animated: true, completion: nil)
    }
}
















