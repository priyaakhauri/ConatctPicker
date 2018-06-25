//
//  SearchPageView.swift
//  ContactDemoApp
//
//  Created by Ankur Akhauri on 23/06/18.
//  Copyright © 2018 DemoApp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchPageView : UIViewController,UISearchBarDelegate
{
    
    @IBOutlet weak var tableViewVar: UITableView!
    
    var firstName : UITextField? = nil
    var secondName : UITextField? = nil
    var emailVar : UITextField? = nil
    var phoneNum : UITextField? = nil
    var countryName : UITextField? = nil
    

    var keyboradHideforEditNoteVarRem : UIBarButtonItem!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
//        let predicate = NSPredicate(format: "completed == FALSE")
        print(searchText)
        let predicate = NSPredicate(format: "firstname contains[c] %@ || secondname contains[c] %@", searchText, searchText)
        fetchedResultsController.fetchRequest.predicate = predicate
        
//        let fetchRequest: NSFetchRequest<ContactDetails> = ContactDetails.fetchRequest()
//        fetchRequest.fetchBatchSize = 20
//        let sortDescriptor = NSSortDescriptor(key: "firstname", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        let predicate = NSPredicate(format: "firstname contains[c] %@", searchText)
//        fetchRequest.predicate = predicate
//
//        let  appDel = UIApplication.shared.delegate as? AppDelegate
        
        // Set the created predicate to our fetch request.
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller
            // will only retrieve more records if necessary.
            //try appDel?.managedObjectContext?.fetch(fetchRequest)
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        self.tableViewVar.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = self.keyboradHideforEditNoteVarRem

    }
    
    
    @IBAction func hideKeyboardBtnFunc(_ sender: UIBarButtonItem) {
        if(self.navigationItem.rightBarButtonItem != nil) {
            keyboradHideforEditNoteVarRem = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
        self.mySearchBar.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(self.navigationItem.rightBarButtonItem != nil) {
            keyboradHideforEditNoteVarRem = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       mySearchBar.delegate = self
        
        
    }
    
    var _fetchedResultsController: NSFetchedResultsController<ContactDetails>? = nil
    
    // The proxy variable to serve as a lazy getter to our
    // fetched results controller.
    var fetchedResultsController: NSFetchedResultsController<ContactDetails>
    {
        
        let  appDel = UIApplication.shared.delegate as? AppDelegate
        // If the variable is already initialized we return that instance.
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If not lets build the required elements for the fetched
        // results controller.
        
        // First we need to create a fetch request with the pretended type.
        let fetchRequest: NSFetchRequest<ContactDetails> = ContactDetails.fetchRequest()
        
        // Set the batch size to a suitable number (optional).
        fetchRequest.fetchBatchSize = 20
        
        // Create at least one sort order attribute and type (ascending\descending)
        let sortDescriptor = NSSortDescriptor(key: "firstname", ascending: true)
        
        // Set the sort objects to the fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Optionally, let's create a filter\predicate.
        // The goal of this predicate is to fetch Tasks that are not yet completed.
        let predicate = NSPredicate(format: "completed == FALSE")
        
        // Set the created predicate to our fetch request.
        fetchRequest.predicate = predicate
        
        // Create the fetched results controller instance with the defined attributes.
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (appDel?.managedObjectContext)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set the delegate of the fetched results controller to the view controller.
        // with this we will get notified whenever occours changes on the data.
        aFetchedResultsController.delegate = self
        
        // Setting the created instance to the view controller instance.
        _fetchedResultsController = aFetchedResultsController
        
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller
            // will only retrieve more records if necessary.
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
}

extension SearchPageView : NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Whenever a change occours on our data, we refresh the table view.
        self.tableViewVar.reloadData()
    }
}

extension SearchPageView : UITableViewDelegate, UITableViewDataSource
{
    /* public func numberOfSections(in tableView: UITableView) -> Int
     {
     // We will use the proxy variable to our fetched results
     // controller and from that we try to get the sections
     // from it. If not available we will ignore and return none (0).
     return self.fetchedResultsController.sections?.count ?? 0
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // We will use the proxy variable to our fetcehed results
        // controller and from that we try to get from that section
        // index access to the number of objects available.
        // If not possible, we will ignore and return 0 objects.
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // First we get a cell from the table view with the identifier "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Then we get the object at the current index from the fetched results controller
        let task = self.fetchedResultsController.object(at: indexPath)
        
        // And update the cell label with the task name
        

        cell.backgroundColor = UIColor.white

        cell.textLabel?.text = task.firstname! + " " +  task.secondname!
        // Finally we return the updated cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            self.tableViewVar.remove(at: indexPath.row)
            //tableViewVar.deleteRows(at: [indexPath], with: .fade)
            let appDel = UIApplication.shared.delegate as? AppDelegate
            
            guard let _context = appDel?.managedObjectContext else { return }
            
            
            let managedObject = self.fetchedResultsController.object(at: indexPath)
            _context.delete(managedObject)
            
            appDel?.saveContext()
            
        }
    }
}
