//
//  SecondViewController.swift
//  Bookmark
//
//  Created by Mohanraj on 27/04/22.
// https://mail.google.com

import UIKit
import GoogleSignIn
import CoreData

class HomeVC: UICollectionViewController {
  
  var link = [Link]()
  var category = [Category]()
  var tagLabel : UITextField!
  let sectionInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 50.0, right: 8.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Bookmark"
    self.retriveData()
  }
  
  @IBAction func signOutBtnPressed(_ sender: UIBarButtonItem) {
    GIDSignIn.sharedInstance.signOut()
    navigationController?.popToRootViewController(animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
  }
  
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
      let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
      let newCategory = Category(entity: entity!, insertInto: context)
      
      newCategory.name = self.tagLabel.text
      do {
        try context.save()
        self.retriveData()
        print(self.category.count)
        self.collectionView.reloadData()
        
      } catch{
        print("context save error")
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      // print("Cancel the operation")
    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    alert.addTextField { (textfield) in
      self.tagLabel = textfield
      self.tagLabel.placeholder = "Type Country Name"
    }
    self.collectionView.reloadData()
    self.present(alert,animated: true,completion: nil)
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
    collectionView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! BookmarkVC
    let indexPath = collectionView.indexPathsForSelectedItems
    destinationVC.selectedCategory = category[indexPath![0].row]
  }
}

//MARK: - CollectionView Delegate & Data Source

extension HomeVC {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return category.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Ccell", for: indexPath) as! CategoryCell
    
    let thisReminder : Category!
    thisReminder = category[indexPath.row]
    cell.layer.cornerRadius = 20
    cell.cateLabel.text = thisReminder.name
    cell.layer.borderWidth = 2
    cell.layer.borderColor = UIColor.black.cgColor
    cell.contentView.isUserInteractionEnabled = false
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let content = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {  _ in
      let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil,discoverabilityTitle: nil, attributes: .destructive) { [self] _ in
        let action = UIAlertController(title: "Confirm Delete tag in \(self.category[indexPath.row].name!)", message: "Deletes all the Bookmark associated with this category", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { [self] _ in
          context.delete(category[indexPath.row])
          self.category.remove(at: indexPath.row)
          try! context.save()
          self.collectionView.reloadData()
        }
        action.addAction(confirm)
        action.addAction(cancel)
        self.present(action, animated: true)
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
    }
    return content
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "WayToBookmark", sender: self)
  }
}

//MARK: - CollectionView Delegate FlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
  
  var cellWidthHeight: CGFloat {
    let insettedWidth = Int((self.view.frame.size.width - 30))
    if (insettedWidth%2) == 0 {
      return CGFloat(insettedWidth / 2)
    } else {
      return CGFloat((insettedWidth - 1) / 2)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: cellWidthHeight, height: cellWidthHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}

