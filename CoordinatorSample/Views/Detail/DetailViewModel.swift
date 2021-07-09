//
//  DetailViewModel.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import RxSwift

class DetailViewModel: BaseViewModel {
    let model: TodoModel
    
    var title = PublishSubject<String>()
    var contents = PublishSubject<String>()
    
    weak var coordinator: HomeCoordinator?
    
    init(model: TodoModel) {
        self.model = model
    }
    
    func addTodo() {
        _ = Observable.combineLatest(self.title, self.contents, self.model.maxID)
            .map { Todo(title: $0, contents: $1, id: $2 + 1) }
            .subscribe(onNext: {
                print("onnext")
                self.model.addTodo(todo: $0)
                self.coordinator?.navigateToHome()
            }, onError: { error in
                print("error")
                print(error)
            }, onCompleted: { 
                print("complete")
            })
    }
}
