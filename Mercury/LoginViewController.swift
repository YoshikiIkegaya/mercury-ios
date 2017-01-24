//
//  LoginViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
  
  var name: String?
  var base64String: String?
  var currentUserEmail: String?
  var uuid: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if FBSDKAccessToken.current() != nil {//Defaults.isConnectedToDB.getBool() == true
      print("一度ログインしているので、次の画面へ遷移します。")
      gotoNextScreen()
    }
    setupFBLoginButtonUI()
  }
  
  func gotoNextScreen() {
    //画面遷移
    if let nc = self.storyboard?.instantiateViewController(withIdentifier: "BaseNC") as? UINavigationController {
      self.present(nc, animated: true, completion: nil)
    }
  }
  
  func setupFBLoginButtonUI() {
    let fbsdkLoginButton = FBSDKLoginButton()
    let rect = CGRect(x: 0, y: self.view.frame.maxY - 80, width: self.view.frame.size.width-100, height: 50.0)
    fbsdkLoginButton.frame = rect
    fbsdkLoginButton.center.x = self.view.center.x
    fbsdkLoginButton.layer.cornerRadius = 25
    fbsdkLoginButton.layer.masksToBounds = true
    fbsdkLoginButton.readPermissions = []
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
      SVProgressHUD.show()
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"]).start {
        (connection, result, error) in
        
        guard let nameValue = (result as AnyObject).value(forKey: "name") as? String else { return }
        self.name = nameValue
        let id = (result as AnyObject).value(forKey: "id")
        guard let url = URL(string: "https://graph.facebook.com/\(id!)/picture?type=large&return_ssl_resorces=1") else { return }
        guard let dataURL = NSData(contentsOf: url) else { return }
        if let email = (result as AnyObject).value(forKey: "email") as? String {
          self.currentUserEmail = email
          Defaults.CurrentUserEmail.set(value: email as AnyObject?)
        }
        
        //Data型のものをString型に変換する
        self.base64String = dataURL.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //アプリ内に保存する
        Defaults.UserName.set(value: self.name as AnyObject?)
        Defaults.ProfileImage.set(value: self.base64String as AnyObject?)
        Defaults.AccessToken.set(value: FBSDKAccessToken.current().tokenString as AnyObject)
        Defaults.ExpirationDate.set(value: FBSDKAccessToken.current().expirationDate.toString() as AnyObject)
        Defaults.FacebookID.set(value: id as AnyObject)
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) {
          (user, error) in
          if Defaults.IsConnectedToDB.getBool() != nil {
            //１度ログインしているので飛ばします
          } else {
            self.uuid = user?.uid
            self.createNewUserDB()
          }
        }
        // ここでユーザー登録APIをコールする
        MercuryAPI.sharedInstance.resisterUserAPI()
        self.gotoNextScreen()
      }
    }
  }
  
  /// Send user info to server
  func createNewUserDB() {
    let firebaseDB = FIRDatabase.database().reference(fromURL: "https://mercury-9aad8.firebaseio.com/")
    //サーバに飛ばす箱
    let user: NSDictionary = ["username": self.name, "profileImage": self.base64String, "uuid": self.uuid]
    firebaseDB.child("users").childByAutoId().setValue(user)
    Defaults.IsConnectedToDB.set(value: true as AnyObject?)
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("ログアウトしました")
  }
}
