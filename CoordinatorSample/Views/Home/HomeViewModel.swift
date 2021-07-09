//
//  HomeViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxCocoa
import RxSwift

class HomeViewModel: ViewModel {
    
    private let todoModel: TodoModel
    weak var coordinator: HomeCoordinator?
    
    struct Input { }
    
    struct Output {
        let todos: Driver<[Todo]>
    }
    
    // MARK: Intializer
    init(todoModel: TodoModel) {
        self.todoModel = todoModel
        
        self.bindModel()
    }
    
    // MARK: Bind Model
    func bindModel() {
        
    }
    
    func selectTodo(index: Int) {
        guard let coordinator = coordinator else { return }
        
        _ = Observable.combineLatest(todoModel.todos, Observable.of(index))
            .take(1)
            .map { $0[$1] }
            .bind(onNext: coordinator.navigateToDetail)
    }
    
    // MARK: Transform
    func transform(input: Input) -> Output {
        return Output(
            todos: self.todoModel.todos.asDriver(onErrorJustReturn: [])
        )
    }
    
    // MARK: Coordinate
    func navigateToAdd() {
        self.coordinator?.navigateToAdd()
    }
}
