//
//  DetailPlanViewController.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class DetailPlanViewController: UIViewController {
  
  @IBOutlet weak var planImageView: UIImageView!
  @IBOutlet weak var giveLabel: UILabel!
  @IBOutlet weak var takeLabel: UILabel!
  @IBOutlet weak var joinButton: UIButton!
  
  var planImageURL: String?
  var giveStr: String?
  var takeStr: String?
  
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func tappedJoinButton(_ sender: Any) {
    print("===== Tapped Join Button =====")
  }
  
  ///: Set Up UI
  func setupUI() {
    self.giveLabel?.text = giveStr
    self.takeLabel?.text = takeStr
    setupParticipateButtonUI()
    setupPlanImageView()
  }
  
  func setupPlanImageView() {
    if let image_url_string = planImageURL {
      let image_url: NSURL = NSURL(string: image_url_string)!
      self.planImageView?.sd_setImage(with: image_url as URL, placeholderImage: placeholderView, options: .lowPriority
        , completed: {
          [weak self] image, error, cacheType, imageUrl in
          if error != nil {
            return
          }
          if image != nil && cacheType == .none {
            self?.planImageView?.fadeIn(duration: FadeType.Slow.rawValue)
          }
      })
      self.planImageView?.contentMode = .scaleAspectFill
      self.planImageView?.layer.masksToBounds = true
    }
  }
  
  func setupParticipateButtonUI() {
    self.joinButton?.backgroundColor = Settings.Color.mercuryColor
    self.joinButton?.setTitle("このプランに参加する", for: .normal)
    self.joinButton?.tintColor = UIColor.white
    self.joinButton?.titleLabel?.font = UIFont(name: "Helvetiva-Bold", size: 14)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
