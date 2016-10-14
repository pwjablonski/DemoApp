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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let screen: UIScreen = UIScreen.mainScreen()
        let bounds: CGRect = screen.bounds
        
        self.window = UIWindow(frame: bounds)
        
        let viewController = PJViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.translucent = false
        self.window!.rootViewController = navController
        
        self.window!.makeKeyAndVisible()
        
        return true
    }




}

