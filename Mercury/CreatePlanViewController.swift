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

class CreatePlanViewController: UIViewController {
  
  @IBOutlet weak var giveTextField: UITextField!
  @IBOutlet weak var takeTextField: UITextField!
  @IBOutlet weak var placeTextField: UITextField!
  @IBOutlet weak var postNewPlanButton: UIButton!
  
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
  
  @IBAction func tappedCloseButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tappedPostNewPlanButton(_ sender: Any) {
    //    print("====== 新しいプランを作成します ======")
    //    MercuryAPI.sharedInstance.postNewPlan(give: "トマトの栽培の仕方を教えるので", take: "革細工のスキルを教えてください", place: "奥多摩", image_url: "https://i.ytimg.com/vi/Ls88xKQVIeA/maxresdefault.jpg", completionHandler: {
    //      self.dismiss(animated: true, completion: nil)
    //    })
  }
  
  func bindViewAndModel() {
    
    giveTextField.text = "give has to be at least \(minLength) characters"
    takeTextField.text = "take has to be at least \(minLength) characters"
    placeTextField.text = "place has to be at least \(minLength) characters"
    
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
    
    everythingValid
      .bindTo(postNewPlanButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
    
    postNewPlanButton.rx.tap
      .subscribe(onNext: { [weak self] in
        print("====== 新しいプランを作成します ======")
        guard let giveText = self!.giveTextField.text else { return }
        guard let takeText = self!.takeTextField.text else { return }
        guard let placeText = self!.placeTextField.text else { return }
        
        
        print("======= DEBUG =======")
        print(giveText)
        print(takeText)
        print(placeText)
        print("==============")
        
        MercuryAPI.sharedInstance.postNewPlan(give: giveText, take: takeText, place: placeText, image_url: self!.tmp_image_url, completionHandler: {
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
    self.postNewPlanButton?.titleLabel?.text = "プランを作成する"
    self.postNewPlanButton?.titleLabel?.font = UIFont(name: "Helvetiva-Bold", size: 14)
  }
}
