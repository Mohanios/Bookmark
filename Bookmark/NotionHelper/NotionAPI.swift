//
//  NotionAPI.swift
//  Bookmark
//
//  Created by Mohanraj on 29/04/22.
//

import Foundation
import SwiftyJSON
import CoreData

final class NotionAPI {
  
  static let shared = NotionAPI()
  var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  var link = [Link]()
  
  //MARK: - POST Notion API 
  func sendDataToNotionAPI(link:String,tag:String) {
    
    let parameters = [
      "parent": ["database_id": "081e231aa31a40df895ed0445f6a74c5"],
      "properties": [
        "Name": ["title" : [["text":["content": link]]]],
        "Link": ["rich_text" : [["text":["content": tag]]]]
      ]] as [String : Any]
    
    let header = [
      "Authorization" : "Bearer secret_aeIrQteisiimWkmly4OyI9ayAt1eubuGrO0apPiH4nK",
      "Accept": "application/json",
      "Notion-Version": "2022-02-22",
      "Content-Type": "application/json"
    ]
    
    let postData = try! JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://api.notion.com/v1/pages")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = header
    request.httpBody = postData as Data
    
    let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      guard let data = data, error == nil else {
        print("Error")
        return
      }
      do {
        let json = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
        //  print(json)
      }
      catch {
        print("Error in Json")
        
      }
    })
    task.resume()
  }
  
  
  //MARK: - Get Data from Notion

  func getNotionAPIData(category: String,completion: @escaping (Result<[Results], Error>) -> Void){

    let header = [
      "Authorization" : "Bearer secret_aeIrQteisiimWkmly4OyI9ayAt1eubuGrO0apPiH4nK",
      "Accept": "application/json",
      "Notion-Version": "2022-02-22",
      "Content-Type": "application/json"
    ]
  
    var request = URLRequest(url: URL(string: "https://api.notion.com/v1/databases/081e231aa31a40df895ed0445f6a74c5/query")! as URL,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = header
    let jsonFilterData = [ "filter": ["property": "Name","title": ["equals": category]]]
    let jsonData = try! JSONSerialization.data(withJSONObject: jsonFilterData, options: .fragmentsAllowed)
    request.httpBody = jsonData as Data
    let task = URLSession.shared.dataTask(with: request) { data, response , error in
      self.persistentContainer.performBackgroundTask { context in
        if let error = error {
          print(error)
        }
        else if let data = data {
          do {
            
            let json = try! JSON(data: data)
            let results = json["results"]
//            print(results.count)
//            print(results)
            for result in results
            {
              self.link = try context.fetch(Link.fetchRequest()) as [Link]
              
              let newLink = Link(context:context)
              let newCategory = Category(context: context)
              
              newLink.url = result.1["properties"]["Link"]["rich_text"][0]["text"]["content"].string
              newLink.title = result.1["properties"]["Name"]["title"][0]["text"]["content"].string
              newCategory.name = result.1["properties"]["Name"]["title"][0]["text"]["content"].string
              newLink.parentCategory = newCategory
              try! context.save()
            }
            do
            {
              self.link = try context.fetch(Link.fetchRequest()) as [Link]
            }
            catch
            {
              print(error)
            }
          }
          catch {
            print(error)
          }
        }
      }
    }
    task.resume()
  }
}

extension Array {
  func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
    //let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var set = Set<T>() //the unique list kept in a Set for fast retrieval
    var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
    for value in self {
      if !set.contains(map(value)) {
        set.insert(map(value))
        arrayOrdered.append(value)
      } else {
        
      }
    }
    return arrayOrdered
  }
}

