//
//  UserInfo.swift
//  Mercury
//
//  Created by toco on 26/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import SwiftyJSON

class UserInfo: NSObject {
  let id: Int?
  let name: String?
  let email: String?
  let image_url: String?
  let created_at: String?
  let updated_at: String?
  
  init(json:JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.email = json["email"].stringValue
    self.image_url = json["image_url"].stringValue
    self.created_at = json["created_at"].stringValue
    self.updated_at = json["updated_at"].stringValue
  }
}

