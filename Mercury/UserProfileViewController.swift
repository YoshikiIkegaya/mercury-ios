//
//  UserProfileViewController.swift
//  Mercury
//
//  Created by toco on 25/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  var userInfo: UserInfo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    self.nameLabel?.text = userInfo?.name
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
