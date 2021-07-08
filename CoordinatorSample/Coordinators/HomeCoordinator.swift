//
//  HomeCoordinator.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController, childCoordinators: [Coordinator] = []) {
        self.presenter = presenter
        self.childCoordinators = childCoordinators
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        self.presenter.pushViewController(homeViewController, animated: true)
    }
    
    func navigateToDetail() {
        let detailViewController = DetailViewController()
        detailViewController.coordinator = self
        
        self.presenter.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToHome() {
        self.presenter.popToRootViewController(animated: true)
    }
}
