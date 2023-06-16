//
//  TagVC.swift
//  Bookmark
//
//  Created by Mohanraj on 04/05/22.
//

import UIKit
import CoreData

class TagVC: UITableViewController {
  
  var category  = [Category]()
  var mainViewController:AddNewBookmarkVC?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.hidesBackButton = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    retriveData()
  }
  
  func retriveData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    do{
      try  category = context.fetch(Category.fetchRequest()) as [Category]
      category = category.unique(){$0.name}
      print(category.count)
    } catch {
      print("error Loading Data\(error)")
    }
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return category.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
    let thisReminder : Category!
    thisReminder = category[indexPath.row]
    cell.textLabel?.text = thisReminder.name
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! AddNewBookmarkVC
    let indexPath = tableView.indexPathForSelectedRow
    destinationVC.selectedCategory2 = category[indexPath!.row]
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "tagReturn", sender: self)
  }
}
