//
//  CircularMenuConstants.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// Constants used throughout the circular menu system
public enum CircularMenuConstants {

    // MARK: - Layout
    public enum Layout {
        public static let buttonSize: CGFloat = 50
        public static let menuRadius: CGFloat = 100
        public static let scaleMultiplier: CGFloat = 1.2
        public static let cornerRadius: CGFloat = 8
        public static let labelMargin: CGFloat = 40
        public static let shadowOffset = CGSize(width: 0, height: 0)
        public static let shadowRadius: CGFloat = 1
        public static let buttonShadowOffset = CGSize(width: 0, height: 0.5)
        public static let buttonShadowRadius: CGFloat = 0.2
        public static let selectedViewScale: CGFloat = 1.2
        public static let radiansConversion: CGFloat = 180
    }

    // MARK: - Animation
    public enum Animation {
        public static let duration: TimeInterval = 0.3
        public static let labelDuration: TimeInterval = 0.2
        public static let buttonAnimationDuration: TimeInterval = 0.1
        public static let presentationDelay: TimeInterval = 0.3
        public static let initialScale: CGFloat = 0.1
        public static let labelScale: CGFloat = 0.8
        public static let buttonHighlightScale: CGFloat = 0.95
    }

    // MARK: - Angles
    public enum Angles {
        public static let arcAngle: CGFloat = CGFloat.pi
        public static let angleStep: CGFloat = 0.6
        public static let tiltAngleLeft: CGFloat = -5
        public static let tiltAngleRight: CGFloat = 5
        public static let quarterPi: CGFloat = CGFloat.pi / 4
        public static let halfPi: CGFloat = CGFloat.pi / 2
        public static let threeQuarterPi: CGFloat = 3 * CGFloat.pi / 4
        public static let negativeQuarterPi: CGFloat = -CGFloat.pi / 4
        public static let negativeThreeQuarterPi: CGFloat = -3 * CGFloat.pi / 4
    }

    // MARK: - Counts
    public enum Counts {
        public static let singleButton: Int = 1
        public static let minButtonCount: Int = 0
        public static let divisionFactor: CGFloat = 2
    }

    // MARK: - Colors
    public enum Colors {
        public static let backgroundAlpha: CGFloat = 0.9
        public static let shadowOpacity: Float = 0.2
        public static let tagBackgroundAlpha: CGFloat = 0.1
        public static let buttonShadowOpacity: Float = 0.2
        public static let hiddenAlpha: CGFloat = 0
        public static let visibleAlpha: CGFloat = 1
        public static let debugAlpha: CGFloat = 0.3
    }

    // MARK: - Typography
    public enum Typography {
        public static let labelFontSize: CGFloat = 24
    }

    // MARK: - Position Ratios
    public struct PositionRatios {
        public static let leftBoundaryRatio: CGFloat = 0.3
        public static let rightBoundaryRatio: CGFloat = 1.7
        public static let topBoundaryRatio: CGFloat = 0.3
        public static let bottomBoundaryRatio: CGFloat = 1.7
    }
}
