//
//  CircularMenuViewController.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// Main view controller for displaying and managing the circular menu
public class CircularMenuViewController: UIViewController {
    var menuButtons: [CircularMenuButton] = []
    var menuItems: [CircularMenuItemProtocol] = []
    private var highlightedButton: CircularMenuButton?
    private var labelView: UIView?
    var centerPoint: CGPoint = .zero

    // View highlighting
    private var highlightManager: ViewHighlightManager?
    var highlightConfiguration: ViewHighlightConfiguration = .withContextualRotation()

    // Long press start position for label placement
    private var initialTouchPosition: CGPoint = .zero

    var buttonSize: CGFloat = CircularMenuConstants.Layout.buttonSize
    var menuRadius: CGFloat = CircularMenuConstants.Layout.menuRadius
    var animationDuration: TimeInterval = CircularMenuConstants.Animation.duration

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor.white.withAlphaComponent(CircularMenuConstants.Colors.backgroundAlpha)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func backgroundTapped() {
        dismissMenu()
    }

    func showMenu(at point: CGPoint, selectedView: UIView, items: [CircularMenuItemProtocol]) {
        centerPoint = point
        initialTouchPosition = point
        menuItems = items

        // Use ViewHighlightManager for view highlighting
        highlightManager = ViewHighlightManager(configuration: highlightConfiguration)
        highlightManager?.highlight(view: selectedView, in: self.view, touchPoint: point)

        createMenuButtons()
        positionButtons(centerPoint: point)
        animateIn()
    }

    func updateTouchLocation(_ location: CGPoint) {
        let newHighlightedButton = findButtonAtLocation(location)

        if newHighlightedButton != highlightedButton {
            highlightedButton?.setHighlighted(false)
            highlightedButton = newHighlightedButton
            highlightedButton?.setHighlighted(true)

            updateLabel(for: highlightedButton)
        }
    }

    private func updateLabel(for button: CircularMenuButton?) {
        labelView?.removeFromSuperview()
        labelView = nil

        guard let button = button else { return }

        let labelText = getLabelText(for: button)
        let labelPosition = calculateLabelPosition(for: button)
        labelView = createLabel(text: labelText, at: labelPosition)

        if let labelView = labelView {
            view.addSubview(labelView)

            labelView.alpha = 0
            labelView.transform = CGAffineTransform(scaleX: CircularMenuConstants.Animation.labelScale, y: CircularMenuConstants.Animation.labelScale)
            UIView.animate(withDuration: CircularMenuConstants.Animation.labelDuration) {
                labelView.alpha = 1
                labelView.transform = CGAffineTransform.identity
            }
        }
    }

    private func getLabelText(for button: CircularMenuButton) -> String {
        return button.menuItem?.name ?? "Action"
    }

    private func calculateLabelPosition(for button: CircularMenuButton) -> LabelPosition {
        let screenBounds = view.bounds
        let screenCenter = CGPoint(x: screenBounds.midX, y: screenBounds.midY)

        let isInitialTouchOnLeft = initialTouchPosition.x < screenCenter.x

        if isInitialTouchOnLeft {
            return .rightCenter
        } else {
            return .leftCenter
        }
    }

    private enum LabelPosition {
        case leftTop, rightTop
        case leftCenter, rightCenter
        case leftBottom, rightBottom
    }

    private func createLabel(text: String, at position: LabelPosition) -> UIView {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: CircularMenuConstants.Typography.labelFontSize, weight: .bold)
        label.textAlignment = .center

        label.sizeToFit()
        let labelSize = label.bounds.size
        let screenBounds = view.bounds
        let margin: CGFloat = CircularMenuConstants.Layout.labelMargin

        var labelFrame: CGRect

        switch position {
        case .leftTop:
            labelFrame = CGRect(
                x: margin,
                y: margin + view.safeAreaInsets.top,
                width: labelSize.width,
                height: labelSize.height
            )
        case .rightTop:
            labelFrame = CGRect(
                x: screenBounds.width - labelSize.width - margin,
                y: margin + view.safeAreaInsets.top,
                width: labelSize.width,
                height: labelSize.height
            )
        case .leftCenter:
            labelFrame = CGRect(
                x: margin,
                y: screenBounds.midY - labelSize.height / 2,
                width: labelSize.width,
                height: labelSize.height
            )
        case .rightCenter:
            labelFrame = CGRect(
                x: screenBounds.width - labelSize.width - margin,
                y: screenBounds.midY - labelSize.height / 2,
                width: labelSize.width,
                height: labelSize.height
            )
        case .leftBottom:
            labelFrame = CGRect(
                x: margin,
                y: screenBounds.height - labelSize.height - margin - view.safeAreaInsets.bottom,
                width: labelSize.width,
                height: labelSize.height
            )
        case .rightBottom:
            labelFrame = CGRect(
                x: screenBounds.width - labelSize.width - margin,
                y: screenBounds.height - labelSize.height - margin - view.safeAreaInsets.bottom,
                width: labelSize.width,
                height: labelSize.height
            )
        }

        label.frame = labelFrame
        return label
    }

    func touchEnded() {
        if let button = highlightedButton, let action = button.menuItem?.action {
            dismissMenu {
                action()
            }
        } else {
            dismissMenu()
        }
    }

    func touchCancelled() {
        dismissMenu()
    }

    private func findButtonAtLocation(_ location: CGPoint) -> CircularMenuButton? {
        for button in menuButtons {
            let distance = sqrt(pow(location.x - button.center.x, 2) + pow(location.y - button.center.y, 2))
            if distance <= buttonSize / 2 {
                return button
            }
        }
        return nil
    }

    func createMenuButtons() {
        menuButtons.forEach { $0.removeFromSuperview() }
        menuButtons.removeAll()

        for item in menuItems {
            let button = createMenuButton(for: item)
            menuButtons.append(button)
        }
    }

    private func createMenuButton(for item: CircularMenuItemProtocol) -> CircularMenuButton {
        let button = CircularMenuButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        button.configure(with: item)
        return button
    }

    func positionButtons(centerPoint: CGPoint) {
        let buttonCount = menuButtons.count
        guard buttonCount > 0 else { return }

        let positions = calculateArcPositions(centerPoint: centerPoint, buttonCount: buttonCount)

        for (index, button) in menuButtons.enumerated() {
            if index < positions.count {
                button.center = positions[index]
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: CircularMenuConstants.Animation.initialScale, y: CircularMenuConstants.Animation.initialScale)
            }
        }
    }

    private func calculateArcPositions(centerPoint: CGPoint, buttonCount: Int) -> [CGPoint] {
        guard buttonCount > 0 else { return [] }

        let screenBounds = view.bounds
        let startAngle = determineStartAngle(for: centerPoint, in: screenBounds)
        let isLeftSide = centerPoint.x < screenBounds.width / 2

        var positions: [CGPoint] = []

        if buttonCount == 1 {
            let angle = startAngle
            let x = centerPoint.x + menuRadius * cos(angle)
            let y = centerPoint.y + menuRadius * sin(angle)
            positions.append(adjustPositionForScreenBounds(CGPoint(x: x, y: y)))
        } else {
            let angleStep: CGFloat = CircularMenuConstants.Angles.angleStep

            for i in 0..<buttonCount {
                let angle: CGFloat

                if isLeftSide {
                    angle = startAngle + angleStep * CGFloat(i)
                } else {
                    angle = startAngle - angleStep * CGFloat(i)
                }

                let x = centerPoint.x + menuRadius * cos(angle)
                let y = centerPoint.y + menuRadius * sin(angle)

                positions.append(adjustPositionForScreenBounds(CGPoint(x: x, y: y)))
            }
        }

        return positions
    }

    private func determineStartAngle(for point: CGPoint, in bounds: CGRect) -> CGFloat {
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2

        let leftBoundary = centerX * CircularMenuConstants.PositionRatios.leftBoundaryRatio
        let topBoundary = centerY * CircularMenuConstants.PositionRatios.topBoundaryRatio

        if point.y > topBoundary {
            return -CGFloat.pi / 2
        } else {
            if point.x < leftBoundary {
                return 0
            } else {
                return CGFloat.pi
            }
        }
    }

    private func adjustPositionForScreenBounds(_ position: CGPoint) -> CGPoint {
        let bounds = view.bounds
        let buttonRadius = buttonSize / 2

        var adjustedX = position.x
        var adjustedY = position.y

        if adjustedX - buttonRadius < bounds.minX {
            adjustedX = bounds.minX + buttonRadius
        } else if adjustedX + buttonRadius > bounds.maxX {
            adjustedX = bounds.maxX - buttonRadius
        }

        if adjustedY - buttonRadius < bounds.minY {
            adjustedY = bounds.minY + buttonRadius
        } else if adjustedY + buttonRadius > bounds.maxY {
            adjustedY = bounds.maxY - buttonRadius
        }

        return CGPoint(x: adjustedX, y: adjustedY)
    }

    private func animateIn() {
        UIView.animate(withDuration: animationDuration, delay: CircularMenuConstants.Animation.presentationDelay, options: [.curveEaseOut]) {
            for button in self.menuButtons {
                button.alpha = 1
                self.view.addSubview(button)
                button.transform = CGAffineTransform.identity
            }
        }
    }

    func dismissMenu(completion: (() -> Void)? = nil) {
        highlightedButton?.setHighlighted(false)
        highlightedButton = nil

        labelView?.removeFromSuperview()
        labelView = nil

        UIView.animate(withDuration: animationDuration, animations: {
            for button in self.menuButtons {
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: CircularMenuConstants.Animation.initialScale, y: CircularMenuConstants.Animation.initialScale)
            }
        }) { [weak self] _ in
            self?.highlightManager?.dismiss(animated: false) {
                self?.dismiss(animated: false) {
                    CircularMenuManager.shared.resetMenuState()
                    completion?()
                }
            }
        }
    }
}
