//
//  ViewHighlightEffect.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// Defines the visual effects applied to a view when highlighted using OptionSet pattern
public struct ViewHighlightEffect: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// No effect - view remains unchanged
    public static let none = ViewHighlightEffect([])

    /// Scale the view
    public static let scale = ViewHighlightEffect(rawValue: 1 << 0)

    /// Rotate the view contextually based on screen position
    public static let contextualRotation = ViewHighlightEffect(rawValue: 1 << 1)

    /// Custom rotation (both sides rotate same direction)
    public static let customRotation = ViewHighlightEffect(rawValue: 1 << 2)

    /// Default effect: no transformations
    public static let `default`: ViewHighlightEffect = .none

    /// Scale and rotation combined
    public static let scaleAndRotation: ViewHighlightEffect = [.scale, .contextualRotation]

    // MARK: - Effect Parameters
    var scaleMultiplier: CGFloat {
        contains(.scale) ? CircularMenuConstants.Layout.scaleMultiplier : 1.0
    }

    var rotationAngle: CGFloat {
        contains(.contextualRotation) || contains(.customRotation) ? 5.0 : 0.0 // degrees
    }

    /// Convert to CGAffineTransform
    func asTransform(viewCenter: CGPoint, screenCenter: CGPoint, customAngle: CGFloat? = nil) -> CGAffineTransform {
        var transform = CGAffineTransform.identity

        // Apply scale
        if contains(.scale) {
            transform = transform.scaledBy(x: scaleMultiplier, y: scaleMultiplier)
        }

        // Apply rotation
        if contains(.contextualRotation) {
            let isLeftSide = viewCenter.x < screenCenter.x
            let degrees = isLeftSide ? -rotationAngle : rotationAngle
            let radians = degrees * .pi / 180
            transform = transform.rotated(by: radians)
        } else if contains(.customRotation), let angle = customAngle {
            let radians = angle * .pi / 180
            transform = transform.rotated(by: radians)
        }

        return transform
    }
}

/// Configuration for view highlight behavior
public struct ViewHighlightConfiguration {
    /// Visual effects to apply when highlighted
    let effect: ViewHighlightEffect

    /// Duration of the highlight animation
    let animationDuration: TimeInterval

    /// Corner radius to apply (if nil, uses original view's corner radius)
    let cornerRadius: CGFloat?

    /// Corner radius multiplier (applied proportionally to scale)
    let cornerRadiusMultiplier: CGFloat

    /// Shadow configuration
    let shadowColor: UIColor
    let shadowOpacity: Float
    let shadowOffset: CGSize
    let shadowRadius: CGFloat

    /// Whether to hide the original view during highlight
    let hideOriginalView: Bool

    /// Custom rotation angle (for customRotation effect)
    let customRotationAngle: CGFloat?

    /// Default configuration - no effects applied
    public static var `default`: ViewHighlightConfiguration {
        ViewHighlightConfiguration(
            effect: .default,
            animationDuration: CircularMenuConstants.Animation.duration,
            cornerRadius: CircularMenuConstants.Layout.cornerRadius,
            cornerRadiusMultiplier: 1.0,
            shadowColor: .clear,
            shadowOpacity: .zero,
            shadowOffset: .zero,
            shadowRadius: .zero,
            hideOriginalView: true,
            customRotationAngle: nil
        )
    }

    /// Configuration with scale only
    public static var withScale: ViewHighlightConfiguration {
        ViewHighlightConfiguration(
            effect: .scale,
            animationDuration: CircularMenuConstants.Animation.duration,
            cornerRadius: CircularMenuConstants.Layout.cornerRadius,
            cornerRadiusMultiplier: CircularMenuConstants.Layout.scaleMultiplier,
            shadowColor: .clear,
            shadowOpacity: .zero,
            shadowOffset: .zero,
            shadowRadius: .zero,
            hideOriginalView: true,
            customRotationAngle: nil
        )
    }

    /// Configuration with contextual rotation based on screen position
    /// Rotation direction is automatically determined: left side tilts left, right side tilts right
    public static func withContextualRotation() -> ViewHighlightConfiguration {
        ViewHighlightConfiguration(
            effect: .contextualRotation,
            animationDuration: CircularMenuConstants.Animation.duration,
            cornerRadius: CircularMenuConstants.Layout.cornerRadius,
            cornerRadiusMultiplier: 1.0,
            shadowColor: .clear,
            shadowOpacity: .zero,
            shadowOffset: .zero,
            shadowRadius: .zero,
            hideOriginalView: true,
            customRotationAngle: nil
        )
    }

    /// Configuration with custom rotation angle (positive = up, negative = down)
    public static func withCustomRotation(angle: CGFloat) -> ViewHighlightConfiguration {
        ViewHighlightConfiguration(
            effect: .customRotation,
            animationDuration: CircularMenuConstants.Animation.duration,
            cornerRadius: CircularMenuConstants.Layout.cornerRadius,
            cornerRadiusMultiplier: 1.0,
            shadowColor: .clear,
            shadowOpacity: .zero,
            shadowOffset: .zero,
            shadowRadius: .zero,
            hideOriginalView: true,
            customRotationAngle: angle
        )
    }

    /// Configuration with scale and contextual rotation
    public static var withScaleAndRotation: ViewHighlightConfiguration {
        ViewHighlightConfiguration(
            effect: .scaleAndRotation,
            animationDuration: CircularMenuConstants.Animation.duration,
            cornerRadius: CircularMenuConstants.Layout.cornerRadius,
            cornerRadiusMultiplier: CircularMenuConstants.Layout.scaleMultiplier,
            shadowColor: .clear,
            shadowOpacity: .zero,
            shadowOffset: .zero,
            shadowRadius: .zero,
            hideOriginalView: true,
            customRotationAngle: nil
        )
    }
}
