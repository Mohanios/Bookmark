//
//  Model.swift
//  Bookmark
//
//  Created by Mohanraj on 10/05/22.
//

import Foundation

struct NotionGet: Codable {
  var results : [Results]
}
struct Results : Codable {
  var properties: Properties
}
struct Properties: Codable {
  var Name : title
  var Link: link
}
struct link: Codable {
  var rich_text : [text]
}
struct title: Codable {
  var title: [text]
}
struct text: Codable {
  var text : content
}
struct content: Codable {
  var content: String
}

