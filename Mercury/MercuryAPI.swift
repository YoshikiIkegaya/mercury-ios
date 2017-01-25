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
    case Plan(Int)
    case Apply(Int)
    case Applicants(Int)
    case Accept(Int)
    case User(Int)
    
    var relativePath: String {
      switch self {
      case .Auth:
        return "auth/register"
      case .Login:
        return "oauth/token"
      case .Plans:
        return "plans"
      case .Plan(let id):
        return "plans/\(id)"
      case .Apply(let id):
        return "plans/\(id)/apply"
      case .Applicants(let id):
        return "plans/\(id)/applicants"
      case .Accept(let id):
        return "plans/\(id)/accept"
      case .User(let id):
        return "user/\(id)"
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
  
  /// Build headers
  func buildHeaders() -> [String: String] {
    let headers = [
      "Accept" : "application/json",
      "Authorization" : "Bearer \(Defaults.AccessToken.getString() ?? "")"
    ]
    print("======= [Defaults.AccessToken] =======")
    print(Defaults.AccessToken.getString() ?? "")
    print("==============")
    return headers
  }
  
  /// user login
  func userLogin(completionHandler: @escaping () -> Void) {
    let env = ProcessInfo.processInfo.environment
    guard let client_id = env["client_id"] else { return }
    guard let client_secret = env["client_secret"] else { return }
    guard let facebookID = Defaults.FacebookID.getString() else { return }
    guard let fbAccessToken = Defaults.FBSDKAccessToken.getString() else { return }
    
    let params = [
      "client_id"     : client_id,
      "client_secret" : client_secret,
      "grant_type"    : "password",
      "username"      : facebookID,
      "password"      : fbAccessToken,
      "scope"         : ""
    ]
    
    Alamofire.request(Path.Login.path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
      .responseJSON { response in
        defer { print("======= Path.Login.path deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        print("======== [USER LOGIN API] ========")
        print(json)
        print("==============================")
        print("======= [access_token] =======")
        guard let acccess_token = json["access_token"].string else { return }
        print("==============")
        Defaults.AccessToken.set(value: acccess_token as AnyObject)
        json.forEach { (_, json) in
          //          print("==============")
          //          print(json)
          //          print("==============")
        }
        completionHandler()
    }
  }
  
  /// Resister user data
  func resisterUserInfo(completionHandler: @escaping () -> Void) {
    guard let name = Defaults.UserName.getString() else { return }
    guard let facebookId = Defaults.FacebookID.getString() else { return }
    guard let fbAccessToken = Defaults.FBSDKAccessToken.getString() else { return }
    guard let profileImage = Defaults.ProfileImage.getString() else { return }
    
    /*
     print("======== [user info] ========")
     print("[name] \(name)")
     print("[facebookId] \(facebookId)")
     print("[fbAccessToken] \(fbAccessToken)")
     print("[profileImage] \(profileImage)")
     print("================")
     */
    
    let params: Parameters = [
      "name"     : name,
      "email"    : facebookId,
      "password" : fbAccessToken,
      "image_url": profileImage
    ]
    
    Alamofire.request(Path.Auth.path, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
      .responseJSON { response in
        defer { print("======= Resister user data deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("====== [RESISTER API] ======")
          print(json)
          if let currentUserCreatorID: Int = json["id"].intValue {
            print("[currentUserCreatorID] \(currentUserCreatorID)")
            Defaults.CurrentUserCreatorID.set(value: currentUserCreatorID as AnyObject)
          }
          print("==============")
        }
        completionHandler()
    }
  }
  
  /// Fetch plans data
  func fetchPlanInfoList(completionHandler: @escaping () -> Void) {
    Alamofire.request(Path.Plans.path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON { response in
        defer { print("======= Fetch plans data deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          let pi = PlanInfo(json: json)
          //          print("======= [GET PLANS] =======")
          //          print(json)
          //          print("==============")
          self.plans.append(pi)
        }
        completionHandler()
    }
  }
  
  /// Get plan with an id
  func getPlan(plan_id: Int, completionHandler: @escaping () -> Void) {
    Alamofire.request(Path.Plan(plan_id).path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON { response in
        defer { print("=======  Get plan with an id deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("==============")
          print(json)
          print("==============")
        }
        completionHandler()
    }
  }
  
  /// Post new plan
  func postNewPlan(give: String, take: String, place: String, image_url: String? = nil, completionHandler: @escaping () -> Void) {
    let params = [
      "give"      : give,
      "take"      : take,
      "place"     : place,
      "image_url" : image_url
    ]
    
    print("============")
    print("[give] \(give)")
    print("[take] \(take)")
    print("[place] \(place)")
    print("[image_url] \(image_url)")
    print("============")
    Alamofire.request(Path.Plans.path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: buildHeaders())
      .responseJSON { response in
        defer { print("=======  Post new plan deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("==============")
          print(json)
          print("==============")
        }
        print("=============== ここから completionHandler をコールします")
        completionHandler()
    }
  }
  
  /// Apply for plan
  func applyForParticipate(plan_id: Int, completionHandler: @escaping () -> Void) {
    print("====== 参加申請を送信します ======")
    Alamofire.request(Path.Apply(plan_id).path, method: .put, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON { response in
        defer { print("=======  Apply to participate deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("====== 参加申請を送信中です... ======")
          print("==============")
          print(json)
          print("==============")
        }
        completionHandler()
    }
  }
  
  /// Fetch plan applicants
  func fetchApplicants(plan_id: Int, completionHandler: @escaping (ApplicantInfo) -> Void) {
    Alamofire.request(Path.Applicants(plan_id).path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON(completionHandler: { response in
        defer { print("=======  Fetch applicants deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          let applicantInfo = ApplicantInfo(json: json)
          print("========== [FETCH PLAN APPLICANTS] ==========")
          print("[applicantInfo_id] \(applicantInfo.id)")
          print("[applicantInfo_name] \(applicantInfo.name)")
          print("[applicantInfo_id] \(applicantInfo.plan_id)")
          print("[applicantInfo_id] \(applicantInfo.creator_id)")
          print("==============")
          completionHandler(applicantInfo)
        }
      })
  }
  
  /// Accept applicant with plan id & user id
  func acceptApplicant(plan_id: Int, applicant_id: Int, completionhandler: @escaping () -> Void) {
    let params = [
      "participant_id" : applicant_id
    ]
    
    Alamofire.request(Path.Accept(plan_id).path, method: .put, parameters: params, encoding: JSONEncoding.default, headers: buildHeaders())
      .responseJSON(completionHandler: { response in
        defer { print("=======  Accept applicants deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("========== [ACCEPT APPLICANTS] ==========")
          print(json)
          print("==============")
        }
      })
    completionhandler()
  }
  
  
  
  /// Fetch User Info
  func fetchUserInfo(user_id: Int, completionHandler: @escaping (UserInfo) -> Void) {
    Alamofire.request(Path.User(user_id).path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON(completionHandler: { response in
        defer { print("======= Fetch User Info deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          let userinfo = UserInfo(json: json)
          print("====== [FETCH USER INFO API] =======")
          print(userinfo.name)
          print(userinfo.image_url)
          print("==============")
          completionHandler(userinfo)
        }
      })
  }
  
  /// Destroy Plan with id
  func deletePlan(plan_id: Int, completionHandler: () -> Void) {
    Alamofire.request(Path.Plan(plan_id).path, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders())
      .responseJSON(completionHandler: { response in
        defer { print("======= Fetch User Info deferred =======") }
        guard let object = response.result.value else { return }
        let json = JSON(object)
        json.forEach { (_, json) in
          print("==========")
          print(json)
          print("==========")
        }
      })
    completionHandler()
  }
}
