//
//  TodoInteractor.swift
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

extension TodoError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noTitle:
            return "No Title"
        case .noContents:
            return "No Contents"
        }
    }
}

protocol TodoInteractorType {
    var todos: BehaviorSubject<[Todo]> { get }
    var maxID: BehaviorSubject<Int> { get }
    
    func removeTodo(todo: Todo)
    func addTodo(todo: Todo)
}

struct TodoInteractor: TodoInteractorType {
    
    // MARK: UserDefaults Keys
    enum TodoKey: String {
        case todos = "hhhh"
    }
    
    // MARK: Todos
    var todos = BehaviorSubject<[Todo]>(value: [])
    var maxID = BehaviorSubject<Int>(value: 0)
    
    // MARK: Initializer
    init() { }
    
    func start() {
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
    
    func removeTodo(at: Int) {
        _ = self.todos
            .observe(on: MainScheduler.asyncInstance)
            .take(1)
            .map { todos in
                let slice = todos[0 ..< at] + todos[at + 1 ..< todos.count]
                return Array(slice)
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
    
    func replaceTodo(with: Todo, index: Int) {
        _ = Observable.combineLatest(self.todos, Observable.of(with))
            .observe(on:MainScheduler.asyncInstance)
            .map { todos, with -> [Todo] in
                let slice = todos[0 ..< index] + [with] + todos[index + 1 ..< todos.count]
                return Array(slice)
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
            return [Todo(title: "테스트1", contents: "마아아아1", id: 1),
                    Todo(title: "테스트2", contents: "마아아아2", id: 2),
                    Todo(title: "테스트3", contents: "마아아아3", id: 3)]
        }
        
        return todos
    }
}
