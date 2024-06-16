//
//  SceneDelegate.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 02.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = createTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Определяем внешний вид SearchForTicketsViewController
    func createSearchForTicketsViewController() -> UINavigationController {
        let searchForTicketsViewController = SearchForTicketsViewController()
        searchForTicketsViewController.tabBarItem = UITabBarItem(title: "Search for tickets", image: UIImage(systemName: "doc.text.magnifyingglass"), tag: 0)
        return UINavigationController(rootViewController: searchForTicketsViewController)
    }
    
    // MARK: Определяем внешний вид FavoritesViewController
    func createFavoritesViewController() -> UINavigationController {
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.loadViewIfNeeded() // Принудительная загрузка view
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        return UINavigationController(rootViewController: favoritesViewController)
    }
    
    // MARK: Определяем внешний вид TabBarController
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        UITabBar.appearance().backgroundColor = .systemGray5
        tabBarController.tabBar.tintColor = .colorSkyBlue
        tabBarController.viewControllers = [createSearchForTicketsViewController(), createFavoritesViewController()]
        return tabBarController
    }
    
}

