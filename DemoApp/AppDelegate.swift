//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/13/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let screen: UIScreen = UIScreen.main
        let bounds: CGRect = screen.bounds
        
        self.window = UIWindow(frame: bounds)
        
        let viewController = PJViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isTranslucent = false
        self.window!.rootViewController = navController
        
        self.window!.makeKeyAndVisible()
        
        return true
    }




}

