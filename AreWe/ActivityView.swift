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

    private let scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false

        return scrollview
    }()

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init() {

        super.init(frame: .zero)

        backgroundColor = .blackColor()

        stackView.addArrangedSubview(areWeLabel)

        picker = ColorPicker { color in
            self.activityField.textColor = color
        }

        activityField.inputAccessoryView = picker
        activityField.delegate = self

        stackView.addArrangedSubview(activityField)
        stackView.addArrangedSubview(dateLabel)

        container.addSubview(stackView)
        scrollview.addSubview(container)
        addSubview(scrollview)

        NSLayoutConstraint.activateConstraints([
            //
            stackView.leftAnchor.constraintEqualToAnchor(scrollview.leftAnchor),
            stackView.rightAnchor.constraintEqualToAnchor(scrollview.rightAnchor),
            stackView.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor),

            //
            scrollview.leftAnchor.constraintEqualToAnchor(container.leftAnchor),
            scrollview.rightAnchor.constraintEqualToAnchor(container.rightAnchor),
            scrollview.topAnchor.constraintEqualToAnchor(container.topAnchor),
            scrollview.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor),
            container.heightAnchor.constraintGreaterThanOrEqualToAnchor(heightAnchor),

            //
            container.widthAnchor.constraintEqualToAnchor(scrollview.widthAnchor),
            scrollview.leftAnchor.constraintEqualToAnchor(leftAnchor),
            scrollview.rightAnchor.constraintEqualToAnchor(rightAnchor),
            scrollview.topAnchor.constraintEqualToAnchor(topAnchor),
            scrollview.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
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
        UIGraphicsBeginImageContextWithOptions(stackView.layer.frame.size, true, 0.0)

        stackView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension ActivityView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
