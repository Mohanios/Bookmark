//
//  AddNewBookmarkVC.swift
//  Bookmark
//
//  Created by Mohanraj on 03/05/22.
//

import UIKit
import CoreData

class AddNewBookmarkVC: UIViewController {
  
  @IBOutlet weak var linkText: UITextField!
  @IBOutlet weak var tagLabel: UILabel!
  
  var selectedCategory1 : Link? = nil
  var selectedCategory2 : Category?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    linkText.text = selectedCategory1?.url
    tagLabel.text = selectedCategory1?.title
    
    let clipboardStr = UIPasteboard.general.string
    if ((clipboardStr?.localizedCaseInsensitiveContains("https://")) == true) {
      linkText.text = clipboardStr
      UIPasteboard.general.string = ""
    }
    navigationItem.hidesBackButton = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    if selectedCategory2 != nil {
      tagLabel.text = selectedCategory2?.name
    }
  }
  
  @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
    
//    if selectedCategory1 == nil{
    
      guard let link = linkText.text , let tag = tagLabel.text else {
        return
      }
      NotionAPI.shared.sendDataToNotionAPI(link: tag, tag: link)
    
//   }
//   else {
//   let appDelegate = UIApplication.shared.delegate as! AppDelegate
//   let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Link")
//      do {
//        let results:NSArray = try context.fetch(request) as NSArray
//        for result in results {
//          let reminder = result as! Link
//          if (reminder == selectedCategory1!) {
//            reminder.url = linkText.text ?? ""
//            reminder.title = tagLabel.text ?? ""
//            try context.save()
//            let vc = HomeVC()
//            navigationController?.pushViewController(vc, animated: true)
//          }
//        }
//      } catch {
//        print("Fetch Failed")
//      }
//    }
    
    for controller in self.navigationController!.viewControllers as Array{
      if controller.isKind(of: HomeVC.self){
        _ = self.navigationController!.popToViewController(controller, animated: true)
        break
      }
    }
  }
}
