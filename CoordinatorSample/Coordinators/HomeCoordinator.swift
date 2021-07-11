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
    let interactor = TodoInteractor()
    
    init(presenter: UINavigationController, childCoordinators: [Coordinator] = []) {
        self.presenter = presenter
        self.childCoordinators = childCoordinators
    }
    
    func start() {
        self.interactor.start()
        let homeViewModel = HomeViewModel(interactor: self.interactor)
        homeViewModel.coordinator = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        self.presenter.pushViewController(homeViewController, animated: true)
    }
    
    func navigateToAdd() {
        let detailViewModel = AddViewModel(interactor: self.interactor)
        detailViewModel.coordinator = self
        let detailViewController = AddViewController(viewModel: detailViewModel)
        
        self.presenter.present(detailViewController, animated: true)
    }
    
    func navigateToDetail(todo: Todo, index: Int) {
        let detailViewModel = AddViewModel(interactor: self.interactor, mode: .edit(todo: todo, index: index))
        detailViewModel.coordinator = self
        let detailViewController = AddViewController(viewModel: detailViewModel)
        
        self.presenter.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToHome() {
        self.presenter.popToRootViewController(animated: true)
    }
}
