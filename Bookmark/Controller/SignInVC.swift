//
//  ViewController.swift
//  Bookmark
//
//  Created by Mohanraj on 27/04/22.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController {
  
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var headingLbl: UILabel!
  
  let signInConfig = GIDConfiguration.init(clientID: "809612078986-7ec9fa0jo47f3rgt4ei6743aes3ujp0u.apps.googleusercontent.com")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loginView.layer.cornerRadius = 30
  }
  
  @IBAction func loginBtnPressed(_ sender: UIButton) {
    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
      print(user!)
      guard error == nil else { return }
      
      self.performSegue(withIdentifier: "goToBookmark", sender: sender)
    }
  }
}
