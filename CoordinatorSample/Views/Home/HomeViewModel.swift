//
//  HomeViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxCocoa
import RxSwift

class HomeViewModel: ViewModel {
    
    private let interactor: TodoInteractor
    weak var coordinator: HomeCoordinator?
    
    struct Input { }
    
    struct Output {
        let todos: Driver<[Todo]>
    }
    
    // MARK: Intializer
    init(interactor: TodoInteractor) {
        self.interactor = interactor
        
        self.bindModel()
    }
    
    // MARK: Bind Model
    func bindModel() {
        
    }
    
    func selectTodo(index: Int) {
        guard let coordinator = coordinator else { return }
        
        _ = Observable.combineLatest(self.interactor.todos, Observable.of(index))
            .take(1)
            .map { ($0[$1], index) }
            .bind(onNext: coordinator.navigateToDetail)
    }
    
    func removeTodo(index: Int) {
        self.interactor.removeTodo(at: index)
    }
    
    // MARK: Transform
    func transform(input: Input) -> Output {
        return Output(
            todos: self.interactor.todos.asDriver(onErrorJustReturn: [])
        )
    }
    
    // MARK: Coordinate
    func navigateToAdd() {
        self.coordinator?.navigateToAdd()
    }
}
