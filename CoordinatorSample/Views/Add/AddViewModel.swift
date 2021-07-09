//
//  AddViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxCocoa
import RxSwift

class AddViewModel: ViewModel {

    let model: TodoModel
    weak var coordinator: HomeCoordinator?

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
    
    init(model: TodoModel, todo: Todo? = nil) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            todo: BehaviorSubject(value: nil),
            addResult: PublishSubject()
        )
        
        let todo = Observable.combineLatest(input.title, input.contents, self.model.maxID)
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
                    self.model.addTodo(todo: todo)
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
