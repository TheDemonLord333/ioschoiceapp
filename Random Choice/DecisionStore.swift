//
//  DecisionStore.swift
//  Random Choice
//

import SwiftUI
import Combine

final class DecisionStore: ObservableObject {
    @Published var options: [DecisionOption] = []
    @Published var history: [HistoryEntry] = []

    private let historyKey = "decision_history"

    init() {
        loadHistory()
    }

    func addOption(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        options.append(DecisionOption(text: trimmed))
    }

    func removeOption(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }

    func loadTemplate(_ template: DecisionTemplate) {
        options = template.options.map { DecisionOption(text: $0) }
    }

    func clearOptions() {
        options.removeAll()
    }

    func recordResult(_ result: String) {
        let entry = HistoryEntry(date: Date(), options: options.map { $0.text }, result: result)
        history.insert(entry, at: 0)
        if history.count > 50 {
            history.removeLast(history.count - 50)
        }
        saveHistory()
    }

    func clearHistory() {
        history.removeAll()
        saveHistory()
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            history = decoded
        }
    }
}
