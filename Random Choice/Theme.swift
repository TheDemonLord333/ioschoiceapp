//
//  Theme.swift
//  Random Choice
//

import SwiftUI

enum Theme {
    static let background = Color(red: 0.04, green: 0.04, blue: 0.05)
    static let surface = Color(red: 0.09, green: 0.09, blue: 0.11)
    static let surfaceElevated = Color(red: 0.13, green: 0.12, blue: 0.15)

    static let spotifyGreen = Color(red: 0.117, green: 0.843, blue: 0.376)
    static let discordPurple = Color(red: 0.345, green: 0.396, blue: 0.949)
    static let demonRed = Color(red: 0.85, green: 0.07, blue: 0.12)
    static let demonRedGlow = Color(red: 1.0, green: 0.2, blue: 0.25)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)

    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.06, green: 0.02, blue: 0.06), Color(red: 0.02, green: 0.02, blue: 0.03)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let accentGradient = LinearGradient(
        colors: [demonRed, discordPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let wheelPalette: [Color] = [
        demonRed, discordPurple, spotifyGreen,
        Color(red: 0.6, green: 0.1, blue: 0.5),
        Color(red: 0.2, green: 0.6, blue: 0.9),
        Color(red: 0.9, green: 0.5, blue: 0.1)
    ]
}

struct GlowText: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.8), radius: 8)
            .shadow(color: color.opacity(0.5), radius: 16)
    }
}

extension View {
    func demonicGlow(_ color: Color = Theme.demonRedGlow) -> some View {
        modifier(GlowText(color: color))
    }
}
