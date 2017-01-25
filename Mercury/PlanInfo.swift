//
//  PlanInfo.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import SwiftyJSON

class PlanInfo: NSObject {
  let id: Int?
  let creator_id: Int?
  let give: String?
  let take: String?
  let place: String?
  let image_url: String?
  let created_at: String?
  let updated_at: String?
  
  init(json:JSON) {
    self.id = json["id"].intValue
    self.creator_id = json["creator_id"].intValue
    self.give = json["give"].stringValue
    self.take = json["take"].stringValue
    self.place = json["place"].stringValue
    self.image_url = json["image_url"].stringValue
    self.created_at = json["created_at"].stringValue
    self.updated_at = json["updated_at"].stringValue
  }
}
