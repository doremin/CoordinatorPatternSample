//
//  AddViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxCocoa
import RxSwift

enum TodoEditMode {
    case add
    case edit(todo: Todo, index: Int)
}

class AddViewModel: ViewModel {

    private let interactor: TodoInteractor
    weak var coordinator: HomeCoordinator?
    private let mode: TodoEditMode

    var disposeBag = DisposeBag()

    struct Input {
        let title: Observable<String?>
        let contents: Observable<String?>
        let addButtonTap: Observable<Void>
    }
    
    struct Output {
        var todo: BehaviorSubject<Todo?>
        var addResult: PublishSubject<Result<Void, TodoError>>
    }
    
    init(interactor: TodoInteractor, mode: TodoEditMode = .add) {
        self.interactor = interactor
        self.mode = mode
    }
    
    func transform(input: Input) -> Output {
        var viewTodo: Todo?
        switch mode {
        case .add:
            viewTodo = nil
        case .edit(let targetTodo, _):
            viewTodo = targetTodo
        }
        
        let output = Output(
            todo: BehaviorSubject(value: viewTodo),
            addResult: PublishSubject()
        )
        
        let todo = Observable.combineLatest(input.title, input.contents, self.interactor.maxID)
            .map { title, contents, maxId -> Result<Todo, TodoError> in
                guard let title = title, !title.isEmpty else {
                    return Result.failure(TodoError.noTitle)
                }

                guard let contents = contents, !contents.isEmpty else {
                    return Result.failure(TodoError.noContents)
                }
                
                return .success(
                    Todo(title: title, contents: contents, id: maxId + 1)
                )
            }
        
        input.addButtonTap
            .withLatestFrom(todo)
            .subscribe(onNext: { result in
                switch result {
                case .success(let todo):
                    switch self.mode {
                    case .add:
                        self.interactor.addTodo(todo: todo)
                    case .edit(_, let index):
                        self.interactor.replaceTodo(with: todo, index: index)
                    }
                    
                    output.addResult.onNext(
                        .success(())
                    )
                case .failure(let error):
                    output.addResult.onNext(
                        .failure(error)
                    )
                }
            })
            .disposed(by: self.disposeBag)
        
        return output
    }
    
    func navigateToHome() {
        self.coordinator?.navigateToHome()
    }
}
