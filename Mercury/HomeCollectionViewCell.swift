//
//  HomeCollectionViewCell.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var giveLabel: UILabel!
  @IBOutlet weak var takeLabel: UILabel!
  
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}

extension HomeCollectionViewCell {
//  func configureForSummary(plan: PlanInfo){
//    if let imgeUrl = plan.image_url {
//      self.imageView?.sd_setImage(with: NSURL(string: imgeUrl) as URL!, placeholderImage: placeholderView, options: .lowPriority)
//    }
//  }
}
