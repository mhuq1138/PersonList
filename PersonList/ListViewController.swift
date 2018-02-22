//
//  ListViewController.swift
//  SubclassingSingleEntityModel
//
//  Created by Mazharul Huq on 1/18/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var persons:[Person] = [Person]()
    var coreDataStack:CoreDataStack!
    var managedContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.tableView.rowHeight = 90.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.coreDataStack = CoreDataStack(modelName: "PersonList")
        self.managedContext = coreDataStack.managedObjectContext
        
        //Fetch Request on Person
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        //Records are fetched using executeFetchRequest
        do{
            self.persons = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()//Table reloaded
        }
        catch{
            let nserror = error as NSError
            print("Could not save \(nserror),(nserror.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let person = persons[indexPath.row]
        var dobString = ""
        if let dob = person.dateOfBirth {
            dobString = "DOB:  \(dateFormatter.string(from: dob as Date))"
        }
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = dobString
        if let favImage = person.favImage{
            cell.imageView?.image = UIImage(data: favImage as Data)
            cell.imageView?.contentMode = .center
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = persons[indexPath.row]
            //Deletes an entry from managed object
            managedContext.delete(person)
            //Save context
            do {
                try managedContext.save()
                persons.remove(at: indexPath.row)//Remove from the array
                self.tableView.reloadData()//Reload table
            } catch let error as NSError {
                print("Could not save \(error),\(error.userInfo)")
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditViewController
        vc.managedContext = self.managedContext
        if segue.identifier == "edit"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                vc.person = persons[indexPath.row]
            }
        }
    }
}
