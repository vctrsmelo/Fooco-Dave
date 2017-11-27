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
		User.sharedInstance.add(contexts: Mocado.contexts)
		User.sharedInstance.add(projects: Mocado.projects)
		User.sharedInstance.set(weekSchedule: Mocado.defaultWeek)
		User.sharedInstance.isCurrentScheduleUpdated = false
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
		
		let navigationController = self.window?.rootViewController as! UINavigationController
		navigationController.pushViewController(homeViewController, animated: false)
		
		navigationController.navigationBar.removeShadowAndBackgroundImage()
        return true
    }

}
