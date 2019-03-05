//
//  AppDelegate.swift
//  SwiftTextKitNotepad
//
//  Created by 张银龙 on 2019/3/5.
//  Copyright © 2019 张银龙. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // style the navigation bar
    let navColor = UIColor(red: 0.175, green: 0.458, blue: 0.831, alpha: 1.0)
    UINavigationBar.appearance().barTintColor = navColor
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    
    return true
  }
}
