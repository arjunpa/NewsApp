//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController: ArticleListViewController = UIStoryboard(storyboardName: .main)
                                                            .instantiateViewController()
        let viewModel = ArticleListViewModel(with: ArticleListRepository(with: APIService()))
        rootViewController.articleListViewModel = viewModel
        viewModel.delegate = rootViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window?.makeKeyAndVisible()
        return true
    }
}
