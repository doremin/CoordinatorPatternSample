//
//  MainCoordinator.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

protocol Coordinator: AnyObject {
    var presenter: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

class MainCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator]
    var presenter: UINavigationController
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.presenter = MainNavigationController()
        self.childCoordinators = []
    }

    func start() {
        self.window.rootViewController = presenter
        
        let homeCoordinator = HomeCoordinator(presenter: self.presenter)
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        self.window.makeKeyAndVisible()
    }
}
