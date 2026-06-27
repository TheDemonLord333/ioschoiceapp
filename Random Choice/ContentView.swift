//
//  ContentView.swift
//  Random Choice
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = DecisionStore()
    @State private var newOption = ""
    @State private var isSpinning = false
    @State private var lastResult: String?
    @State private var showHistory = false
    @State private var showResult = false
    @State private var spinTrigger = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        templatesSection

                        WheelView(options: store.options.map { $0.text }, isSpinning: $isSpinning, spinTrigger: $spinTrigger) { result in
                            lastResult = result
                            store.recordResult(result)
                            showResult = true
                        }
                        .padding(.top, 8)

                        spinButton

                        optionsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Zufalls-Entscheider")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(Theme.demonRedGlow)
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                HistoryView(store: store)
            }
            .alert("Das Schicksal hat entschieden", isPresented: $showResult) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(lastResult ?? "")
            }
        }
        .preferredColorScheme(.dark)
        .tint(Theme.demonRedGlow)
    }

    private var templatesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Templates.all) { template in
                    Button {
                        store.loadTemplate(template)
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: template.icon)
                                .font(.title2)
                            Text(template.name)
                                .font(.caption)
                        }
                        .frame(width: 80, height: 70)
                        .background(Theme.surface)
                        .foregroundColor(Theme.textPrimary)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Theme.accentGradient, lineWidth: 1.5)
                        )
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var spinButton: some View {
        Button {
            spinWheel()
        } label: {
            Text(isSpinning ? "Dreht sich…" : "Schicksal befragen")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.accentGradient)
                .foregroundColor(.white)
                .cornerRadius(16)
                .demonicGlow(Theme.demonRed)
        }
        .disabled(store.options.count < 2 || isSpinning)
        .opacity(store.options.count < 2 ? 0.5 : 1)
    }

    private func spinWheel() {
        spinTrigger += 1
    }

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Optionen")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)

            HStack {
                TextField("Neue Option eingeben…", text: $newOption)
                    .padding(10)
                    .background(Theme.surface)
                    .cornerRadius(10)
                    .foregroundColor(Theme.textPrimary)
                    .onSubmit(addOption)

                Button(action: addOption) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.spotifyGreen)
                }
            }

            if store.options.isEmpty {
                Text("Füge mindestens zwei Optionen hinzu, um das Schicksal zu befragen.")
                    .font(.footnote)
                    .foregroundColor(Theme.textSecondary)
            } else {
                ForEach(store.options) { option in
                    HStack {
                        Circle()
                            .fill(Theme.demonRed)
                            .frame(width: 8, height: 8)
                        Text(option.text)
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                        Button {
                            if let index = store.options.firstIndex(of: option) {
                                store.removeOption(at: IndexSet(integer: index))
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(10)
                    .background(Theme.surface)
                    .cornerRadius(10)
                }

                Button(role: .destructive) {
                    store.clearOptions()
                } label: {
                    Text("Alle löschen")
                        .font(.footnote)
                        .foregroundColor(Theme.demonRedGlow)
                }
            }
        }
    }

    private func addOption() {
        store.addOption(newOption)
        newOption = ""
    }
}

#Preview {
    ContentView()
}
