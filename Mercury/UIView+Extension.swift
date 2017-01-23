//
//  UIView+Extension.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

enum FadeType: TimeInterval {
  case
  Normal = 0.2,
  Slow = 1.0
}

extension UIView {
//  func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
//    fadeIn(type.rawValue, completed: completed)
//  }
  
  /** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
  func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
    alpha = 0
    isHidden = false
    
    UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      
      self.alpha = CGFloat(1.0)
      
    }){ finished in
      completed?()
    }
  }
  
//  func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
//    fadeOut(type.rawValue, completed: completed)
//  }
  /** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
  func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
    UIView.animate(withDuration: duration
      , animations: {
        self.alpha = 0
    }) { [weak self] finished in
      self?.isHidden = true
      self?.alpha = 1
      completed?()
    }
  }
}
