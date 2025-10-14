//
//  CircularMenuManager.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// Manager class for presenting and controlling circular menus
public class CircularMenuManager {
    public static let shared = CircularMenuManager()
    private init() {}

    private var currentMenuViewController: CircularMenuViewController?
    private var isMenuPresented: Bool = false

    /// Shows a circular menu at the specified point
    /// - Parameters:
    ///   - point: The center point for the menu in the presenting view's coordinate system
    ///   - selectedView: The view that triggered the menu (will be highlighted)
    ///   - items: Array of menu items to display
    ///   - presentingViewController: The view controller to present from
    ///   - highlightConfiguration: Configuration for view highlighting effects
    ///   - customization: Optional closure to customize the menu view controller
    public func showMenu(
        at point: CGPoint,
        selectedView: UIView,
        items: [CircularMenuItemProtocol],
        from presentingViewController: UIViewController,
        highlightConfiguration: ViewHighlightConfiguration = .withContextualRotation(),
        customization: ((CircularMenuViewController) -> Void)? = nil
    ) {
        // Ignore if menu is already presented
        guard !isMenuPresented else {
            print("Menu is already presented, ignoring new menu request")
            return
        }

        isMenuPresented = true
        let menuVC = CircularMenuViewController()
        menuVC.modalPresentationStyle = .overFullScreen
        menuVC.modalTransitionStyle = .crossDissolve
        menuVC.highlightConfiguration = highlightConfiguration

        customization?(menuVC)
        currentMenuViewController = menuVC

        presentingViewController.present(menuVC, animated: false) {
            menuVC.showMenu(at: point, selectedView: selectedView, items: items)
        }
    }

    /// Adds a long press gesture to show a circular menu
    /// - Parameters:
    ///   - view: The view to add the gesture to
    ///   - targetView: The view to highlight when menu appears
    ///   - items: Array of menu items to display
    ///   - presentingViewController: The view controller to present from
    ///   - minimumPressDuration: Minimum duration for long press (default: 0.5 seconds)
    ///   - highlightConfiguration: Configuration for view highlighting effects
    ///   - customization: Optional closure to customize the menu view controller
    public func addLongPressMenu(
        to view: UIView,
        targetView: UIView,
        items: [CircularMenuItemProtocol],
        presentingViewController: UIViewController,
        minimumPressDuration: TimeInterval = 0.5,
        highlightConfiguration: ViewHighlightConfiguration = .withContextualRotation(),
        customization: ((CircularMenuViewController) -> Void)? = nil
    ) {
        let gestureHandler = LongPressGestureHandler(
            targetView: targetView,
            items: items,
            presentingViewController: presentingViewController,
            highlightConfiguration: highlightConfiguration,
            customization: customization
        )

        let longPress = UILongPressGestureRecognizer(target: gestureHandler, action: #selector(LongPressGestureHandler.handleGesture(_:)))
        longPress.minimumPressDuration = minimumPressDuration

        view.addGestureRecognizer(longPress)
        view.setAssociatedLongPressHandler(gestureHandler)
    }

    /// Adds a tap gesture to show a circular menu
    /// - Parameters:
    ///   - view: The view to add the gesture to
    ///   - targetView: The view to highlight when menu appears
    ///   - items: Array of menu items to display
    ///   - presentingViewController: The view controller to present from
    ///   - customization: Optional closure to customize the menu view controller
    public func addTapMenu(
        to view: UIView,
        targetView: UIView,
        items: [CircularMenuItemProtocol],
        presentingViewController: UIViewController,
        customization: ((CircularMenuViewController) -> Void)? = nil
    ) {
        let gestureHandler = TapGestureHandler(
            targetView: targetView,
            items: items,
            presentingViewController: presentingViewController,
            customization: customization
        )

        let tap = UITapGestureRecognizer(target: gestureHandler, action: #selector(TapGestureHandler.handleGesture(_:)))
        view.addGestureRecognizer(tap)
        view.setAssociatedTapHandler(gestureHandler)
    }

    // MARK: - Touch handling (Long Press only)
    func updateTouchLocation(_ location: CGPoint) {
        currentMenuViewController?.updateTouchLocation(location)
    }

    func touchEnded() {
        currentMenuViewController?.touchEnded()
    }

    func touchCancelled() {
        currentMenuViewController?.touchCancelled()
    }

    func resetMenuState() {
        currentMenuViewController = nil
        isMenuPresented = false
    }
}
