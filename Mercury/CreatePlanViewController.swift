//
//  CreatePlanViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController {
  
  @IBOutlet weak var postNewPlanButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPostNewPlanButtonUI()
  }
  
  @IBAction func tappedCloseButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tappedPostNewPlanButton(_ sender: Any) {
    print("====== 新しいプランを作成します ======")
    MercuryAPI.sharedInstance.postNewPlan(give: "トマトの栽培の仕方を教えるので", take: "革細工のスキルを教えてください", place: "奥多摩", image_url: "http://blogs.c.yimg.jp/res/blog-6c-4e/everythings44125036/folder/789836/26/38074726/img_1", completionHandler: {
      self.dismiss(animated: true, completion: nil)
    })
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
