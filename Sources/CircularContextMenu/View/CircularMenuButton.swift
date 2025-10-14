//
//  CircularMenuButton.swift
//  CircularMenu
//
//  Created by 송재훈
//

import UIKit

/// A button used in the circular menu
public class CircularMenuButton: UIButton {
    var menuItem: CircularMenuItemProtocol?
    private var originalBackgroundColor: UIColor = .white
    private var baseConfiguration: UIButton.Configuration!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .black
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 17)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowRadius = 0.2

        self.baseConfiguration = config
        self.configuration = config
    }

    func configure(with item: CircularMenuItemProtocol) {
        self.menuItem = item
        originalBackgroundColor = item.backgroundColor

        var config = baseConfiguration!
        config.image = item.image
        config.baseBackgroundColor = item.backgroundColor
        config.baseForegroundColor = .black

        self.configuration = config
    }

    func setHighlighted(_ highlighted: Bool) {
        UIView.animate(withDuration: 0.15) {
            var config = self.baseConfiguration!
            config.image = self.menuItem?.image

            if highlighted {
                config.baseBackgroundColor = .black
                config.baseForegroundColor = .white
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else {
                config.baseBackgroundColor = self.originalBackgroundColor
                config.baseForegroundColor = .black
                self.transform = CGAffineTransform.identity
            }

            self.configuration = config
        }
    }
}
