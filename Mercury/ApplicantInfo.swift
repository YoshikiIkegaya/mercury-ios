//
//  ApplicantInfo.swift
//  Mercury
//
//  Created by toco on 25/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import SwiftyJSON

class ApplicantInfo: NSObject {
  let id: Int?
  let name: String?
  let email: String?
  let profile_image_url: String?
  let user_created_at: String?
  let user_updated_at: String?
  let plan_id: Int?
  let creator_id: Int?
  let plan_created_at: String?
  let plan_updated_at: String?
  
  init(json:JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.email = json["email"].stringValue
    self.profile_image_url = json["image_url"].stringValue
    self.user_created_at = json["created_at"].stringValue
    self.user_updated_at = json["updated_at"].stringValue
    let pivot = json["pivot"]
    self.plan_id = pivot["plan_id"].intValue
    self.creator_id = pivot["user_id"].intValue
    self.plan_created_at = pivot["created_at"].stringValue
    self.plan_updated_at = pivot["updated_at"].stringValue
  }
}
