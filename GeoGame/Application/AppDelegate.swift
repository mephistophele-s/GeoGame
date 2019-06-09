//
//  AppDelegate.swift
//  GeoGame
//
//  Created by Anastasia on 5/15/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyDN22WSS2ZNbI_9sy2JIyOs3yJvvRYaZO8")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
