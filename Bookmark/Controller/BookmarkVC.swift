//
//  BookmarkVC.swift
//  Bookmark
//
//  Created by Mohanraj on 29/04/22.
//

import UIKit
import CoreData
import LinkPresentation

class BookmarkVC: UITableViewController {
  
  var selectedCategory : Category?
  var newData = [Bookmark]()
  var link = [Link]()
  
  private let provider = LPMetadataProvider()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedCategory?.name
    getNotionData()
    retriveData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  func retriveData() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchrecquest = Link.fetchRequest()
    let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    fetchrecquest.predicate = predicate
    do{
      let tempLink = try context.fetch(fetchrecquest)
      link = tempLink.unique(){$0.title}
    } catch {
      print("error Loading Data\(error)")
    }
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return link.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell") as! BookmarkCell
    
    guard let urlString = ( link[indexPath.row].url),let url = URL(string: urlString)  else { return cell}
    provider.startFetchingMetadata(for: url) { metadata, error in
      
      guard error == nil else {
        assertionFailure("Error")
        return
      }
      
      guard
        let metadata = metadata,
        error == nil
      else { return }
      DispatchQueue.main.async {
        let linkView = LPLinkView(metadata: metadata)
        cell.contentView.addSubview(linkView)
        linkView.frame =  cell.contentView.bounds
        
        cell.titleLabel.text = metadata.title
        cell.descriptionLabel.text = metadata.description
        
        //   print(metadata.title ?? "No Title")
        //  cell.tagLabel.text = link[indexPath.row].title
        //   cell.shortLinkLabel.text = metadata.
        //   cell.iconImageView.image = metadata.i
        
      }
    }
    return cell
  }
  
  //  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  //    guard let cell = tableView.cellForRow(at: indexPath) else { return }
  //  let linkView = LPLinkView(metadata: metadata)
  //
  //    cell.contentView.addSubview(linkView)
  //    linkView.frame =  cell.contentView.bounds
  //
  //
  //  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
      context.delete(link[indexPath.row])
      link.remove(at: indexPath.row)
      try! context.save()
      do{
        try context.save()
      }catch{
        print("Delete Failed")
      }
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    default:
      return
    }
  }
}

extension BookmarkVC {
  
  func getNotionData(){
    NotionAPI.shared.getNotionAPIData(category: title ?? "") {[weak self] result in
      switch result {
      case .success(let data):
        self?.newData = data.compactMap({
          Bookmark(name: $0.properties.Name.title.first?.text.content ?? "", link: $0.properties.Link.rich_text.first?.text.content ?? "")
        })
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}



