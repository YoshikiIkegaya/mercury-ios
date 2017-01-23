//
//  PlanInfo.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import SwiftyJSON

class PlanInfo: NSObject {
  let user_id: Int?
  let give: String?
  let take: String?
  let place: String?
  let image_url: String?
  
  init(json:JSON) {
    self.user_id = json["user_id"].intValue
    self.give = json["give"].stringValue
    self.take = json["take"].stringValue
    self.place = json["place"].stringValue
    self.image_url = json["image_url"].stringValue
  }
}
