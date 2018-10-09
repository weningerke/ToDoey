//
//  ViewController.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 01..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

//    override var prefersStatusBarHidden: Bool{
//        return true
//    }
    var itemArray = [Item]()
    //MARK: selectedCategory
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Item betöltés
        loadItems()

    }
    
    //MARK: - Tableview Datasource Methods
    
    
    
    // Megszámolja hogy mennyi sorra van szükség és létrehozza azt
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//      Ternary operator ==»
//      value = condition ? valueIfTrue : valueIfFalse
//      cell.accessoryType = item.done == true ? .checkmark : .none
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//
//        cell.textLabel?.text = itemArray[indexPath.row].title
//
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
//
//        return cell
//    }
    

    //MARK: - TableView Delegate Methods
    
    
    
    // Kiirattuk a tábla tartalmát a Debug konzolra
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print(itemArray[indexPath.row])

  				 
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        //MARK: pipa kezelése
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if  itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else{
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
        
    // animáltuk a kattintást
        tableView.deselectRow(at: indexPath, animated: true)
       
    }

    // MARK: - Add New Item
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
        
        }
        alert.addAction(action)
        
        alert.addAction(cancel)

//        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
//            //what will happen once the user click the Add Item button our UIAlert
//            //print(textField.text)
//
//
//            if textField.text != nil {
//
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//
//            self.saveItems()
//            }else{
//
//            }
//        }))
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//        }))

        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // ?
        self.present(alert, animated: true, completion: nil)
    
}
    func saveItems() {
        
        
        do{
           try context.save()
        }catch{
            print("Error saveing context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
      
        
        
        do{
            itemArray = try context.fetch(request)
            
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        self.tableView.reloadData()
        
    }

}

    //MARK: - SearchBar Method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
//        let sortDescripter  = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescripter]
        
        
        loadItems(with: request, predicate: predicate)
        
//        do{
//            itemArray = try context.fetch(request)
//
//        }catch{
//            print("Search error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
        
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
















