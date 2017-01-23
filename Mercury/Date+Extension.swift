//
//  Date+Extension.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import Foundation

extension Date {
  func toString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: self)
  }
}
//2017-03-24 03:05:36 +0000
