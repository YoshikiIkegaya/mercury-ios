//
//  DetailPlanViewController.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailPlanViewController: UIViewController {
  
  @IBOutlet weak var planImageView: UIImageView!
  @IBOutlet weak var planerIconImageButton: UIButton!
  @IBOutlet weak var giveLabel: UILabel!
  @IBOutlet weak var takeLabel: UILabel!
  @IBOutlet weak var applyButton: UIButton!
  
  /// tmp IBOutlet
  @IBOutlet weak var applicantNameLabel: UILabel!
  @IBOutlet weak var acceptButton: UIButton!
  
  var plan: PlanInfo?
  var applicant: ApplicantInfo?
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  @IBAction func tappedAcceptBtn(_ sender: Any) {
    //承認する
    SVProgressHUD.show()
    guard let planId = self.plan?.id else { return }
    guard let applicantId = self.applicant?.id else { return }
    MercuryAPI.sharedInstance.acceptApplicant(plan_id: planId, applicant_id: applicantId, completionhandler: {
      if let applicantName = self.applicant?.name {
        print("========== \(applicantName) さんの参加申請を承認しました ==========")
      }
      SVProgressHUD.dismiss()
      self.navigationController?.popViewController(animated: true)
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
  
  /// プラン作成者のプロフィール画面に遷移する
  @IBAction func tappedPlanerIconButton(_ sender: Any) {
    print("===== Tapped Planer Icon Button =====")
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
    
    /// プランの作成者が自分でない時、承認アクションを表示しない
    if isApplyButtonEnabled == true {
      self.acceptButton?.isHidden = true
      self.applicantNameLabel?.isHidden = true
    } else {
      if let applicantName = applicant?.name {
        self.applicantNameLabel.text = applicantName
      }
    }
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
