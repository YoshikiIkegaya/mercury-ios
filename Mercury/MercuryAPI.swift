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
    static let BaseURL = "https://mercury-app.herokuapp.com/"
    static let MercuryAPIURL = "https://mercury-app.herokuapp.com/api/"
  }
  
  private enum Path {
    case Auth
    case Login
    case Plans
    
    var relativePath: String {
      switch self {
      case .Auth:
        return "auth/register"
      case .Login:
        return "oauth/token"
      case .Plans:
        return "plans"
      }
    }
    
    var path: String {
      switch self {
      case.Login:
        return (NSURL(string: Constants.BaseURL)?.appendingPathComponent(relativePath)?.absoluteString) ?? ""
      default:
        return (NSURL(string: Constants.MercuryAPIURL)?.appendingPathComponent(relativePath)?.absoluteString) ?? ""
      }
    }
  }
  
  func userLogin() {
    
    let env = ProcessInfo.processInfo.environment
    guard let client_id = env["client_id"] else { return }
    guard let client_secret = env["client_secret"] else { return }
    guard let email = Defaults.CurrentUserEmail.getString() else { return }
    guard let password = Defaults.FacebookID.getString() else { return }
    
    let params = [
      "client_id"     : client_id,
      "client_secret" : client_secret,
      "grant_type"    : "password",
      "username"      : email,
      "password"      : password,
      "scope"         : ""
    ]
    
    Alamofire.request("https://mercury-app.herokuapp.com/oauth/token", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
  
  /// resister user data
  func resisterUserAPI() {
    guard let name = Defaults.UserName.getString() else { return }
    guard let email = Defaults.CurrentUserEmail.getString() else { return }
    guard let password = Defaults.FacebookID.getString() else { return }
    
    let params: Parameters = [
      "name" : name,
      "email" : email,
      "password" : password
    ]
    
    print(Path.Auth.path)
    
    Alamofire.request(Path.Auth.path, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
      defer {
        print("======= resisterUserAPI deferred =======")
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
  
  /// fetch plans data
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
      }
      completionHandler()
    }
  }
}
