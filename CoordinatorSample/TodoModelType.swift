//
//  TodoModelType.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import Foundation
import RxSwift

protocol TodoModelType {
    var todos: PublishSubject<[Todo]> { get set }
    
    func removeTodo(todo: Todo)
    func addTodo(todo: Todo)
}

struct TodoModel: TodoModelType {

    // MARK: Singleton
    static let shared = TodoModel()
    
    var todos = PublishSubject<[Todo]>()
    
    // MARK: Initializer
    private init() {
        let model = [
            Todo(title: "테스트1", contents: "마아아아1", id: 1),
            Todo(title: "테스트2", contents: "마아아아2", id: 2),
            Todo(title: "테스트3", contents: "마아아아3", id: 3)
        ]

        self.todos.onNext(model)
    }
    
    // MARK: Action
    func removeTodo(todo: Todo) {
        _ = self.todos
            .map { todos in
                todos.filter { $0 != todo }
            }
            .ifEmpty(switchTo: .error(RxError.unknown))
            .subscribe(onNext: {
                self.todos.onNext($0)
            })
    }
    
    func addTodo(todo: Todo) {
        _ = self.todos
            .map { todos in
                todos + [todo]
            }
            .subscribe(onNext: {
                self.todos.onNext($0)
            })
    }

    func saveTodos() {
        let encoder = try? PropertyListEncoder()
        
    }
}
