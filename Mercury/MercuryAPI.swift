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
  
  func resisterUserAPI() {
    let name = Defaults.UserName.getString()
    let email = Defaults.CurrentUserEmail.getString()
    let password = Defaults.FacebookID.getString()
    
    let params: Parameters = [
      "name" : name,
      "email" : email,
      "password" : password
    ]
    
    Alamofire.request("https://mercury-app.herokuapp.com/api/auth/register", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
      defer {
        print("======= deferred =======")
      }
      guard let object = response.result.value else {
        return
      }
      
      print("==============")
      print(object)
      print("==============")
      
      let json = JSON(object)
      json.forEach { (_, json) in
        print("==============")
        print(json)
        print("==============")
      }
    }
    
  }
  
  // : fetch data from API
  func fetchPlanInfoList(completionHandler: @escaping () -> Void) {
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
//        print("=========")
//        if let giveStr = pi.give {
//          print(giveStr)
//        }
//        print("=========")
      }
      completionHandler()
    }
  }
}
