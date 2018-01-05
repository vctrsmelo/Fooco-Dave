//
//  AppDelegate.swift
//  Fooco
//
//  Created by Victor S Melo on 20/10/17.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
		
		let navigationController = self.window?.rootViewController as! UINavigationController
		navigationController.pushViewController(homeViewController, animated: false)
		
        UINavigationBar.appearance().removeShadowAndBackgroundImage()
        
        return true
    }

}
