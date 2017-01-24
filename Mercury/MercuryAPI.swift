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
  
  private struct Constants {
    static let MercuryAPIURL = "https://mercury-app.herokuapp.com/api/"
  }
  
    private enum Path {
      case Auth
      case Plans
      
      
      var relativePath: String {
        switch self {
        case .Auth:
          return "auth/register"
        case .Plans:
          return "plans"
        
        }
      }
      
      var path: String {
        return (NSURL(string: Constants.MercuryAPIURL)?.appendingPathComponent(relativePath)?.absoluteString) ?? ""
      }
  }
  
  
  func resisterUserAPI() {
    guard let name = Defaults.UserName.getString() else { return }
    guard let email = Defaults.CurrentUserEmail.getString() else { return }
    guard let password = Defaults.FacebookID.getString() else { return }
    
    let params: Parameters = [
      "name" : name,
      "email" : email,
      "password" : password
    ]
    
    // : resister useer data
    Alamofire.request(Path.Auth.path, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
  
  // : fetch plans data
  func fetchPlanInfoList(completionHandler: @escaping () -> Void) {
    Alamofire.request(Path.Plans.path).responseJSON { response in
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
