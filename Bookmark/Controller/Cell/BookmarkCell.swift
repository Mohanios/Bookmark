//
//  BookmarkCell.swift
//  Bookmark
//
//  Created by Mohanraj on 04/05/22.
//

import UIKit

class BookmarkCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tagLabel: UILabel!
  @IBOutlet weak var shortLinkLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

class Bookmark {
  var name : String
  var link : String
  
  init(name:String,link:String){
    self.name = name
    self.link = link
  }
}

