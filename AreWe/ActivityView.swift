//
//  ActivityView.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import UIKit

final class ActivityView: UIView {
    private var picker: ColorPicker?

    private let areWeLabel: UILabel = {
        let label = UILabel()
        label.text = "Are We".uppercaseString
        label.font = .boldSystemFontOfSize(80)
        label.textColor = .whiteColor()
        label.textAlignment = .Center

        return label
    }()

    private let activityField: UITextField = {
        let field = UITextField()
        field.text = "Eating Tacos".uppercaseString
        field.textAlignment = .Center
        field.returnKeyType = .Done
        field.textColor = .yellowColor()
        field.font = .boldSystemFontOfSize(50)

        return field
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Today".uppercaseString
        label.font = .boldSystemFontOfSize(80)
        label.textColor = .whiteColor()
        label.textAlignment = .Center

        return label
    }()

    private let container = UIStackView()

    init() {

        super.init(frame: .zero)

        backgroundColor = .blackColor()

        container.axis = .Vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(areWeLabel)

        picker = ColorPicker { color in
            self.activityField.textColor = color
        }
        activityField.inputAccessoryView = picker
        container.addArrangedSubview(activityField)
        container.addArrangedSubview(dateLabel)

        addSubview(container)

        NSLayoutConstraint.activateConstraints([
            container.leftAnchor.constraintEqualToAnchor(leftAnchor),
            container.rightAnchor.constraintEqualToAnchor(rightAnchor),
            container.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        picker?.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: 45))
    }

    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(container.layer.frame.size, true, 0.0)

        container.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
