//
//  Settings.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import Foundation
import UIKit

enum Settings {
  static let baseURL = "https://mercury-app.herokuapp.com/"
  
  enum Size {
    static let collectionCellSize = CGSize(width: 150.0, height: 200.0)
  }
  enum Color {
    static let hogeColor = UIColor.black
    static let mercuryColor = UIColor(red:0.92, green:0.21, blue:0.18, alpha:1.00)
  }
}
