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
  @IBOutlet weak var applyButton: UIButton!
  
  var plan: PlanInfo?
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  var isApplyButtonEnabled: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let currentUserCreatorID = Defaults.CurrentUserCreatorID.getInt()
    print("==========")
    print("[currentUserCreatorID] \(currentUserCreatorID)")
    print("==========")
    if plan?.creator_id == currentUserCreatorID {
      isApplyButtonEnabled = false
    }
    setupUI()
  }
  
  /// これはテスト用のボタンです
  @IBAction func tmpGetApplicants(_ sender: Any) {
    /// このプランに対する申請者の一覧を取得する
    guard let planId = plan?.id else { return }
    MercuryAPI.sharedInstance.fetchApplicants(plan_id: planId, completionHandler: {
      self.dismiss(animated: true, completion: {
        print("============ ここで申請完了のモーダルを表示する ============")
      })
    })
  }
  
  /// プランに参加申請をする or 自分が作成したプランを削除する
  @IBAction func tappedApplyButton(_ sender: Any) {
    if isApplyButtonEnabled == false {
      print("========== このプランを削除します ==========")
      /// TODO: 本当に削除をするか確認をするアラートを表示する
      
      guard let planId = self.plan?.id else { return }
      MercuryAPI.sharedInstance.deletePlan(plan_id: planId, completionHandler: {
        print("===== プラン\(planId)を削除しました =====")
        /// TODO: 削除を完了したことを伝えるモーダルを表示する
        
        self.navigationController?.popViewController(animated: true)
      })
    } else {
      self.applyButton?.isEnabled = false
      self.applyButton?.setTitle("参加申請済み", for: .disabled)
      // 参加申請APIをコールする
      guard let planId = self.plan?.id else { return }
      print("===== プラン\(planId)に参加します =====")
      print(planId)
      print("================")
      MercuryAPI.sharedInstance.applyForParticipate(plan_id: planId, completionHandler: {
        print("========== 参加申請の送信を完了しました ==========")
        /// TODO: 参加申請が完了したことを通知するアラートを表示する
      })
    }
  }
  
  @IBAction func tappedPlanerIconButton(_ sender: Any) {
    print("===== Tapped Planer Icon Button =====")
    /// プラン作成者のプロフィール画面に遷移する
    guard let creator_id = plan?.creator_id else { return }
    MercuryAPI.sharedInstance.fetchUserInfo(user_id: creator_id, completionHandler: { (userInfo) -> Void in
      if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileViewController {
        vc.userInfo = userInfo
        self.navigationController?.pushViewController(vc, animated: true)
      }
    })
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
    if isApplyButtonEnabled == false {
      self.applyButton?.setTitle("このプランを削除する", for: .normal)
      self.applyButton?.backgroundColor = UIColor.lightGray
    } else {
      self.applyButton?.setTitle("このプランに参加する", for: .normal)
      self.applyButton?.backgroundColor = Settings.Color.mercuryColor
    }
    self.applyButton?.tintColor = UIColor.white
    self.applyButton?.titleLabel?.font = UIFont(name: "Helvetiva-Bold", size: 14)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
