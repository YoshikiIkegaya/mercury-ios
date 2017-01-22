//
//  LoginViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupFBLoginButtonUI()
    
  }
  
  func setupFBLoginButtonUI() {
    let fbsdkLoginButton = FBSDKLoginButton()
    let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width-100, height: 50.0)
    fbsdkLoginButton.frame = rect
    fbsdkLoginButton.center = self.view.center
    fbsdkLoginButton.delegate = self
    self.view.addSubview(fbsdkLoginButton)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    print("ログインしました")
    if error != nil {
      //エラーの時
      print(error)
    } else if result.isCancelled {
      //
    } else {
      //取得
      getFacebookUserInfo()
    }
  }
  
  func getFacebookUserInfo(){
    if FBSDKAccessToken.current() != nil {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name"]).start {
        (connection, result, error) in
        
      }
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("ログアウトしました")
  }
}
