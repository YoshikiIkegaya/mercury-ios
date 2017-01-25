//
//  CreatePlanViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

class CreatePlanViewController: UIViewController {
  
  @IBOutlet weak var giveTextField: UITextField!
  @IBOutlet weak var takeTextField: UITextField!
  @IBOutlet weak var placeTextField: UITextField!
  @IBOutlet weak var postNewPlanButton: UIButton!
  @IBOutlet weak var newPlanImageButton: UIButton!
  
  @IBOutlet weak var giveAlertLabel: UILabel!
  @IBOutlet weak var takeAlertLabel: UILabel!
  @IBOutlet weak var placeAlertLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  private let throttleInterval = 0.1
  
  let minLength = 3
  let maxLength = 140
  let tmp_image_url = "https://i.ytimg.com/vi/Ls88xKQVIeA/maxresdefault.jpg"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPostNewPlanButtonUI()
    bindViewAndModel()
  }
  
  @IBAction func launchCamera(_ sender: Any) {
    print("カメラを起動します")
  }
  
  @IBAction func tappedCloseButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func bindViewAndModel() {
    /// TODO: 文字数が最大を超えた時
    giveAlertLabel.text = "\(minLength)文字以上で入力して下さい。"
    takeAlertLabel.text = "\(minLength)文字以上で入力して下さい。"
    placeAlertLabel.text = "\(minLength)文字以上で入力して下さい。"
    
    giveTextField.placeholder  = "例) プログラミングを教えます。"
    takeTextField.placeholder  = "例) ケーキの作り方を教えてください。"
    placeTextField.placeholder = "例) 新宿駅"
    
    let giveTextFieldValid = giveTextField.rx.text.orEmpty
      .map { $0.characters.count >= self.minLength }
      .shareReplay(1)
    
    let takeTextFieldValid = takeTextField.rx.text.orEmpty
      .map { $0.characters.count >= self.minLength }
      .shareReplay(1)
    
    let placeTextFieldValid = placeTextField.rx.text.orEmpty
      .map { $0.characters.count >= self.minLength }
      .shareReplay(1)
    
    let everythingValid = Observable.combineLatest(giveTextFieldValid, takeTextFieldValid, placeTextFieldValid) { $0 && $1 && $2 }
      .shareReplay(1)
    
    giveTextFieldValid
      .bindTo(giveAlertLabel.rx.isHidden)
      .addDisposableTo(disposeBag)
    
    takeTextFieldValid
      .bindTo(takeAlertLabel.rx.isHidden)
      .addDisposableTo(disposeBag)
    
    placeTextFieldValid
      .bindTo(placeAlertLabel.rx.isHidden)
      .addDisposableTo(disposeBag)
    
    everythingValid
      .bindTo(postNewPlanButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
    
    /// Tapped postNewPlanButton
    postNewPlanButton.rx.tap
      .subscribe(onNext: { [weak self] in
        print("====== 新しいプランを作成します ======")
        SVProgressHUD.show()
        self?.postNewPlanButton?.isEnabled = false
        guard let giveText = self?.giveTextField?.text else { return }
        guard let takeText = self?.takeTextField?.text else { return }
        guard let placeText = self?.placeTextField?.text else { return }
        MercuryAPI.sharedInstance.postNewPlan(give: giveText, take: takeText, place: placeText, image_url: self?.tmp_image_url, completionHandler: {
          print("====== 新しいプランを作成しました ======")
          self?.dismiss(animated: true, completion: nil)
        })
      })
      .addDisposableTo(disposeBag)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setupPostNewPlanButtonUI() {
    self.postNewPlanButton?.backgroundColor = Settings.Color.mercuryColor
    self.postNewPlanButton?.setTitle("プランを作成する", for: .normal)
    self.postNewPlanButton?.tintColor = UIColor.white
    self.postNewPlanButton?.titleLabel?.font = UIFont(name: "Helvetiva-Bold", size: 20)
  }
}
