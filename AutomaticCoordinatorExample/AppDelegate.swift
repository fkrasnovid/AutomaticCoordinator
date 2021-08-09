//
//  AppDelegate.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit
import AutomaticCoordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: AnyCoordinator<Void>?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AutomaticCoordinatorConfiguration.enabledDebugLog(true)
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navVc = SystemNavigationController(hideNavigationBar: true)
		window?.rootViewController = navVc

		let appCoordinator = CoordinatorFactory.shared.makeApplicationCoordinator(
			router: ApplicationRouter(rootController: navVc)
		)

		appCoordinator.start()
		self.appCoordinator = appCoordinator
		return true
	}
}

