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
        let homeViewModel = HomeViewModel(todoModel: TodoModel.shared)
        homeViewModel.coordinator = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        self.presenter.pushViewController(homeViewController, animated: true)
    }
    
    func navigateToDetail() {
        let detailViewModel = DetailViewModel(model: TodoModel.shared)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        
        self.presenter.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToHome() {
        self.presenter.popToRootViewController(animated: true)
    }
}
