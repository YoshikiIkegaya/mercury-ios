//
//  UIImage+Extension.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

extension UIImage {
  class func imageWithColor(color: UIColor) -> UIImage {
    let __view = UIView(frame: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
    __view.backgroundColor = color
    UIGraphicsBeginImageContext(__view.frame.size)
    let __context = UIGraphicsGetCurrentContext()
    __view.layer.render(in: __context!)
    let __image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return __image!
  }
}
