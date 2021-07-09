//
//  HomeViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxRelay

class HomeViewModel: BaseViewModel {
    
    private let todoModel: TodoModel
    
    weak var coordinator: HomeCoordinator?
    
    var todos = BehaviorRelay<[Todo]>(value: [])
    
    init(todoModel: TodoModel) {
        self.todoModel = todoModel
        
        _ = self.todoModel.todos
            .bind(onNext: self.todos.accept)
    }
    
    func navigateToDetail() {
        self.coordinator?.navigateToDetail()
    }
}
