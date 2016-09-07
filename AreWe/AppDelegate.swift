//
//  AppDelegate.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let navigationController = UINavigationController(rootViewController: ActivityViewController())

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        
        return true
    }

}

