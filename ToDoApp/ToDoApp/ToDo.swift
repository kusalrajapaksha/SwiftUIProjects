//
//  ToDo.swift
//  ToDoApp
//
//  Created by Kusal Rajapaksha on 2024-01-07.
//

import Foundation

enum TodoStatus: String {
    case pending
    case completed
}


struct Todo: Identifiable, Hashable {
    let id: Int
    let title: String
    let date: Date
    var status: TodoStatus
}

