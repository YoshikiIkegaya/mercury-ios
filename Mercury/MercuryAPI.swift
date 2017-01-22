//
//  MercuryAPI.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias APICompletionHandler = (_ json: JSON?, _ error: NSError?) -> Void

class MercuryAPI: NSObject {
  
  static var sharedInstance = MercuryAPI()
  var plans = [PlanInfo]()
  
  // : fetch data from API
  func fetchPlanInfoList() {
    Alamofire.request("https://mercury-app.herokuapp.com/api/plans").responseJSON { response in
      defer {
        print("======= deferred =======")
      }
      guard let object = response.result.value else {
        return
      }
      let json = JSON(object)
      json.forEach { (_, json) in
        let pi = PlanInfo(json: json)
        self.plans.append(pi)
        print("=========")
        if let giveStr = pi.give {
          print(giveStr)
        }
        print("=========")
      }
    }
  }
}
