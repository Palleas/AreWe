//
//  ViewController.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit

final class ActivityView: UIView {

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

    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(container.layer.frame.size, true, 0.0)

        container.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

final class ActivityViewController: UIViewController {

    override func loadView() {
        view = ActivityView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(didTapDone))
    }

    func didTapDone() {
        let screenshot = (view as! ActivityView).screenshot()

    }

}

