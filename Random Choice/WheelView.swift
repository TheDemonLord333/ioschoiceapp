//
//  WheelView.swift
//  Random Choice
//

import SwiftUI

struct WheelView: View {
    let options: [String]
    @Binding var isSpinning: Bool
    @Binding var spinTrigger: Int
    var onResult: (String) -> Void

    @State private var rotation: Double = 0

    private var slice: Double {
        options.isEmpty ? 360 : 360.0 / Double(options.count)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.surfaceElevated)
                .frame(width: 300, height: 300)
                .shadow(color: Theme.demonRed.opacity(0.5), radius: 20)

            wheel
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(rotation))

            Circle()
                .fill(Theme.background)
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Theme.demonRedGlow, lineWidth: 2))

            Triangle()
                .fill(Theme.demonRedGlow)
                .frame(width: 24, height: 28)
                .rotationEffect(.degrees(180))
                .offset(y: -160)
                .demonicGlow()
        }
        .onTapGesture {
            spin()
        }
        .onChange(of: spinTrigger) { _, _ in
            spin()
        }
    }

    private var wheel: some View {
        ZStack {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                WheelSlice(
                    startAngle: .degrees(slice * Double(index)),
                    endAngle: .degrees(slice * Double(index + 1))
                )
                .fill(Theme.wheelPalette[index % Theme.wheelPalette.count])
                .overlay(
                    Text(option)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(slice * Double(index) + slice / 2))
                        .offset(labelOffset(forIndex: index))
                        .lineLimit(1)
                )
            }
        }
        .clipShape(Circle())
        .overlay(Circle().stroke(Theme.demonRed, lineWidth: 3))
    }

    private func labelOffset(forIndex index: Int) -> CGSize {
        let angle = (slice * Double(index) + slice / 2 - 90) * .pi / 180
        let radius: CGFloat = 90
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
    }

    func spin() {
        guard !options.isEmpty, !isSpinning else { return }
        isSpinning = true

        let resultIndex = Int.random(in: 0..<options.count)
        let targetSliceCenter = slice * Double(resultIndex) + slice / 2
        let fullSpins = Double(Int.random(in: 5...8)) * 360
        let finalRotation = fullSpins + (360 - targetSliceCenter)

        withAnimation(.timingCurve(0.15, 0.85, 0.25, 1.0, duration: 3.2)) {
            rotation += finalRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            isSpinning = false
            onResult(options[resultIndex])
        }
    }
}

private struct WheelSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle - .degrees(90), endAngle: endAngle - .degrees(90), clockwise: false)
        path.closeSubpath()
        return path
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
