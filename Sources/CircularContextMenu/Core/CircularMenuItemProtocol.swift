//
//  CircularMenuItemProtocol.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// Protocol defining a menu item for the circular menu
public protocol CircularMenuItemProtocol {
    var name: String { get }
    var image: UIImage? { get }
    var backgroundColor: UIColor { get }
    var action: (() -> Void)? { get }
}

/// Default implementation of CircularMenuItemProtocol
public struct CircularMenuItem: CircularMenuItemProtocol {
    public let name: String
    public let image: UIImage?
    public let backgroundColor: UIColor
    public let action: (() -> Void)?

    public init(name: String, image: UIImage?, backgroundColor: UIColor = .white, action: (() -> Void)? = nil) {
        self.name = name
        self.image = image
        self.backgroundColor = backgroundColor
        self.action = action
    }
}
