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
  @IBOutlet weak var planerIconImageButton: UIButton!
  @IBOutlet weak var giveLabel: UILabel!
  @IBOutlet weak var takeLabel: UILabel!
  @IBOutlet weak var applyPlanButton: UIButton!
  
  var plan: PlanInfo?
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func tmpGetApplicants(_ sender: Any) {
    guard let planId = plan?.id else {return}
    MercuryAPI.sharedInstance.fetchApplicants(plan_id: planId)
  }
  
  @IBAction func tappedApplyPlanButton(_ sender: Any) {
    
    self.applyPlanButton?.isEnabled = false
    // 参加申請APIをコールする
    guard let planId = self.plan?.id else { return }
    print("===== プラン\(planId)に参加します =====")
    print(planId)
    print("================")
    MercuryAPI.sharedInstance.applyForParticipate(plan_id: planId, completionHandler: {
      print("========== 参加申請の送信を完了しました ==========")
    })
  }
  
  @IBAction func tappedPlanerIconButton(_ sender: Any) {
    print("===== Tapped Planer Icon Button =====")
    
    /// プラン作成者のプロフィール画面に遷移する
  }
  
  ///: Set Up UI
  func setupUI() {
    self.giveLabel?.text = plan?.give
    self.takeLabel?.text = plan?.take
    setupApplyButtonUI()
    setupPlanImageView()
  }
  
  func setupPlanImageView() {
    if let image_url_string = plan?.image_url {
      if let image_url: NSURL = NSURL(string: image_url_string) {
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
  }
  
  func setupApplyButtonUI() {
    self.applyPlanButton?.backgroundColor = Settings.Color.mercuryColor
    self.applyPlanButton?.setTitle("このプランに参加する", for: .normal)
    self.applyPlanButton?.tintColor = UIColor.white
    self.applyPlanButton?.titleLabel?.font = UIFont(name: "Helvetiva-Bold", size: 14)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
