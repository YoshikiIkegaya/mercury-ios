//
//  Router.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

//import Foundation
//import Alamofire
//
//enum Router: URLRequestConvertible {
//  
//  static let baseURLString = Settings.baseURL + "/api/v1"
//  
//  // Categories
//  case GetPlans
////  case GetSummary(Int)
//  
//  var URLRequest: NSMutableURLRequest {
//    let (path, parameters): (String, [String: AnyObject]?) = {
//      switch self {
//      case .GetPlans:
//        return ("/plans", nil)
//      
////      case .GetSummary(let id):
////        return ("/summaries/\(id)", nil) //id	Int	8311	8311
////        
////      case .GetTimeline(let first_id, let last_id):
////        return (
////          "/summaries/timeline",
////          ["first_summary_id": first_id, "last_summary_id": last_id]
////        )
//      
//      }
//    }()
//    
//    let URL = NSURL(string: Router.baseURLString)!
//    let URLRequest = NSURLRequest(url: URL.appendingPathComponent(path)!).
//    let encoding = Alamofire.ParameterEncoding//Alamofire.ParameterEncoding.URL//ParameterEncoding.URL
//    return encoding.encode(URLRequest, parameters: parameters).0
//  }
//}
//
