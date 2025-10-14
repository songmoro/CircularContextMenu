//
//  TapMenuViewController.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// A tap-based variant of the circular menu where items are selected by tapping
class TapMenuViewController: CircularMenuViewController {
    override func updateTouchLocation(_ location: CGPoint) { }

    override func touchEnded() {
        dismissMenu()
    }

    override func touchCancelled() {
        dismissMenu()
    }

    override func createMenuButtons() {
        menuButtons.forEach { $0.removeFromSuperview() }
        menuButtons.removeAll()

        for item in menuItems {
            let button = createTapMenuButton(for: item)
            menuButtons.append(button)
            view.addSubview(button)
        }
    }

    private func createTapMenuButton(for item: CircularMenuItemProtocol) -> CircularMenuButton {
        let button = CircularMenuButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        button.configure(with: item)
        button.addTarget(self, action: #selector(tapMenuButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func tapMenuButtonTapped(_ sender: CircularMenuButton) {
        sender.menuItem?.action?()
        dismissMenu()
    }
}
