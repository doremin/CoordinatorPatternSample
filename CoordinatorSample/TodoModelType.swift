//
//  TodoModelType.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import Foundation
import RxSwift

enum TodoError: Error {
    case noTitle
    case noContents
}

protocol TodoModelType {
    var todos: BehaviorSubject<[Todo]> { get }
    var maxID: BehaviorSubject<Int> { get }
    
    func removeTodo(todo: Todo)
    func addTodo(todo: Todo)
}

struct TodoModel: TodoModelType {

    // MARK: Singleton
    static let shared = TodoModel()
    
    // MARK: UserDefaults Keys
    enum TodoKey: String {
        case todos = "hhhh"
    }
    
    // MARK: Todos
    var todos = BehaviorSubject<[Todo]>(value: [])
    var maxID = BehaviorSubject<Int>(value: 0)
    
    // MARK: Initializer
    private init() {
        let todos = self.loadTodos()

        self.maxID.onNext(todos[todos.count - 1].id)
        self.todos.onNext(todos)
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

        self.saveTodos()
    }
    
    func addTodo(todo: Todo) {
        _ = Observable.combineLatest(self.todos, Observable.of(todo))
            .observe(on: MainScheduler.asyncInstance)
            .map { $0 + [$1] }
            .take(1)
            .bind(onNext: {
                self.maxID.onNext(todo.id)
                self.todos.onNext($0)
            })

        self.saveTodos()
    }
    
    func replaceTodo(todo: Todo, index: Int) {
        _ = Observable.combineLatest(self.todos, Observable.of(todo))
            .map { todos, todo in
                return todos[0 ..< index] + [todo] + todos[index + 1 ..< todos.count]
            }
            .bind(onNext: self.todos.onNext)
        
        self.saveTodos()
    }

    func saveTodos() {
        _ = self.todos
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let encodedValue = try? PropertyListEncoder().encode($0)
                UserDefaults.standard.setValue(encodedValue, forKey: TodoKey.todos.rawValue)
            })
    }
    
    func loadTodos() -> [Todo] {
        guard let data = UserDefaults.standard.value(forKey: TodoKey.todos.rawValue) as? Data else {
            return [
                // Default Data When Launched Firsts
                Todo(title: "테스트1", contents: "마아아아1", id: 1),
                Todo(title: "테스트2", contents: "마아아아2", id: 2),
                Todo(title: "테스트3", contents: "마아아아3", id: 3)
            ]
        }

        guard let todos = try? PropertyListDecoder().decode([Todo].self, from: data) else {
            return []
        }
        
        return todos
    }
}
