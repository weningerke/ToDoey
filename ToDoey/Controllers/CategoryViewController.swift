//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 03..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()

    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        // ?
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    
    
    func saveCategory() {
        
        
        do{
            try context.save()
        }catch{
            print("Error saveing context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            print("Error loading categories \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - TableView Delegate Methods //
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
