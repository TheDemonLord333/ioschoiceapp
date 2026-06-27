//
//  HistoryView.swift
//  Random Choice
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var store: DecisionStore
    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()

                if store.history.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "moon.stars.fill")
                            .font(.largeTitle)
                            .foregroundColor(Theme.demonRedGlow)
                        Text("Noch keine Entscheidungen getroffen.")
                            .foregroundColor(Theme.textSecondary)
                    }
                } else {
                    List {
                        ForEach(store.history) { entry in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(entry.result)
                                    .font(.headline)
                                    .foregroundColor(Theme.demonRedGlow)
                                Text(entry.options.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                                Text(dateFormatter.string(from: entry.date))
                                    .font(.caption2)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Theme.surface)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Verlauf")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !store.history.isEmpty {
                        Button("Löschen", role: .destructive) {
                            store.clearHistory()
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fertig") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
