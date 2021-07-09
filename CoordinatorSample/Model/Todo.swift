//
//  Todo.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

struct Todo: Codable {
    var title: String
    var contents: String
    let id: Int
    
    init(title: String, contents: String, id: Int) {
        self.title = title
        self.contents = contents
        self.id = id
    }
}

extension Todo: Equatable {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id
    }
}
