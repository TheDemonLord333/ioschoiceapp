//
//  Models.swift
//  Random Choice
//

import Foundation

struct DecisionOption: Identifiable, Codable, Equatable {
    var id = UUID()
    var text: String
}

struct HistoryEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var date: Date
    var options: [String]
    var result: String
}

struct DecisionTemplate: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var options: [String]
}

enum Templates {
    static let all: [DecisionTemplate] = [
        DecisionTemplate(name: "Essen", icon: "fork.knife", options: [
            "Pizza", "Sushi", "Burger", "Pasta", "Döner", "Salat"
        ]),
        DecisionTemplate(name: "Film", icon: "film", options: [
            "Horror", "Komödie", "Action", "Sci-Fi", "Drama", "Anime"
        ]),
        DecisionTemplate(name: "Aktivität", icon: "figure.run", options: [
            "Spazieren", "Zocken", "Lesen", "Sport", "Serie schauen", "Kochen"
        ])
    ]
}
