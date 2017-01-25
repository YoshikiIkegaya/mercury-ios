//
//  AppDelegate.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupThirdPartyLibraries(application, launchOptions: launchOptions)
    checkUserIsLoggedin()
    return true
  }
  
  func checkUserIsLoggedin() {
    
    // Facebook認証が期限切れしている場合
    // Facebook認証ログインする
    // 保留あとから期限と日付を比較する
     //2017-03-24 03:05:36 +0000
    if Defaults.ExpirationDate.getString() == nil {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      if let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
        window?.rootViewController? = vc
        window?.makeKeyAndVisible()
      }
    } else {
      MercuryAPI.sharedInstance.resisterUserInfo(completionHandler:{
        MercuryAPI.sharedInstance.userLogin()
      })
    }
    
  }
  
  func setupThirdPartyLibraries(_ application: UIApplication,  launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    FIRApp.configure()
  }
  
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url,
                                                                       sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                       annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    return handle
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

