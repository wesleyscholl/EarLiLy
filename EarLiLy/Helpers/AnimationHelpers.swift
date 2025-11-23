//
//  AnimationHelpers.swift
//  EarLiLy
//
//  Reusable animation utilities for delightful interactions
//

import SwiftUI

// MARK: - Bounce Animation
struct BounceModifier: ViewModifier {
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(trigger ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: trigger)
    }
}

extension View {
    func bounce(trigger: Bool) -> some View {
        modifier(BounceModifier(trigger: trigger))
    }
}

// MARK: - Wiggle Animation
struct WiggleModifier: ViewModifier {
    let trigger: Bool
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                        rotation = 5
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        rotation = 0
                    }
                }
            }
    }
}

extension View {
    func wiggle(trigger: Bool) -> some View {
        modifier(WiggleModifier(trigger: trigger))
    }
}

// MARK: - Confetti Effect
struct ConfettiView: View {
    let count: Int = 30
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                ConfettiPiece(index: index, animate: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    @State private var location = CGPoint(x: UIScreen.main.bounds.width / 2, y: -20)
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0
    
    private var randomColor: Color {
        [.red, .blue, .green, .yellow, .orange, .purple, .pink].randomElement() ?? .blue
    }
    
    var body: some View {
        Circle()
            .fill(randomColor)
            .frame(width: 10, height: 10)
            .position(location)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.easeOut(duration: Double.random(in: 1...2))) {
                    location = CGPoint(
                        x: Double.random(in: 0...UIScreen.main.bounds.width),
                        y: UIScreen.main.bounds.height + 20
                    )
                    opacity = 0
                    rotation = Double.random(in: 0...360)
                }
            }
    }
}

// MARK: - Shimmer Effect
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Pulse Animation
struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseModifier())
    }
}

// MARK: - Star Rating View
struct StarRatingView: View {
    let rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .scaleEffect(index <= rating ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6).delay(Double(index) * 0.1), value: rating)
            }
        }
    }
}

// MARK: - Card Flip Effect
struct FlipEffect: GeometryEffect {
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    var angle: Double
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, CGFloat(angle * .pi / 180), 0, 1, 0)
        return ProjectionTransform(transform)
    }
}
