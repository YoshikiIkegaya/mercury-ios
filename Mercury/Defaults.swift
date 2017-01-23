//
//  Defaults.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import Foundation

enum Defaults: String {
  case AccessToken = "AccessToken"
  case UserName = "UserName"
  case ProfileImage = "ProfileImage"
  case IsConnectedToDB = "IsConnectedToDB"
  case ExpirationDate = "ExpirationDate"
  
  func set(value: AnyObject?) {
    UserDefaults.standard.set(value, forKey: self.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  func getString() -> String? {
    return UserDefaults.standard.string(forKey: self.rawValue)
  }
  
  func getBool() -> Bool? {
    return UserDefaults.standard.bool(forKey: self.rawValue)
  }
}
