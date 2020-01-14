//
//  ToDoTableViewController.swift
//  DoIt
//
//  Created by Anuj Regmi on 12/25/19.
//  Copyright © 2019 Anuj Regmi. All rights reserved.
//

import UIKit
import CoreData

//do not use UserDefault for large data. The Item object array cannot be used in user default. It can only take standard datatypes and custom ones like about array of type "Items" class.

class ToDoTableViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            //load the data only when the value of selectedCategory is set.
            loadData()
        }
    }
    
    //in: .userDomainMask is the place where where we are going to save their personal item associated to this app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //create a userDefault object
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//        let newItem = Item()
//        newItem.title = "Code"
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Eat"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Code again"
//        itemArray.append(newItem2)

//        if let item = defaults.array(forKey: "itemsInTheArray") as? [Item] {
//            itemArray = item
//        }
        
        
    }
    
    //MARK - DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //check if the done property is true or false and accordingly check and uncheck.
        
        //ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //flip the done property after being tapped
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])  //deletes the current indexPath from the context before saving it
//        itemArray.remove(at: indexPath.row)    //removes the current indexPath from the tableView
        
        savedItem()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)  //deselects the row after selecting it.
        
        tableView.reloadData()
    }
    
    //MARK - Add new Item
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what happpens when the user clicks on "Add Item" button
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            newItem.parentCatagory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "itemsInTheArray")
            
            self.savedItem()
        }
        
        //add textField in the alert
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Type your to do."
            
            //pass the alertTextField to textField
            
            textField = alertTextField
        }
        
        //add the action to the alert
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - data manupulation method
    func savedItem(){
        
        //let encoder = PropertyListEncoder()
        
        do{
//            let data = try encoder.encode(itemArray)
//            //write the data to the filepath
//            try data.write(to: dataFilePath!)
            
            try context.save()
        } catch {
//            print("error encoding the data:\(error)")
              print("error saving context: \(error)")
       }
        
        
        self.tableView.reloadData()
    }
    
    //with is an external parameter and request is internal. This function uses internal parameter
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), searchPredicate: NSPredicate? = nil){ //provide a default value
        //methods for encoding and decoding
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            let decoder = PropertyListDecoder()
//
//            // set the items array to the decoded items.plist
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("error decoding the data \(error)")
//            }
//        }
        
        // Coredata
        //let request : NSFetchRequest<Item> = Item.fetchRequest() //it is going to fetch results in the form of "Items"
        
        let Categorypredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalpredicate = searchPredicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalpredicate, Categorypredicate])
            
            request.predicate = compoundPredicate
        } else {
            request.predicate = Categorypredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Cannot fetch the data from the persistant container: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - searchbar delegate methods

extension ToDoTableViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // create a query           it is basically a query language
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //[cd] not case and diacritic sensitive
        
        //add the predicate to the request
        //request.predicate = predicate
        
        //sort the list
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]   //it is an array
        
        loadData(with: request, searchPredicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            // run this code in the main thread because automatically it runs in background
            DispatchQueue.main.async {
                //search bar resign its active state
                searchBar.resignFirstResponder()
            }
        
        }
    }
}
    

    
