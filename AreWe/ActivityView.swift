//
//  ActivityView.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityViewDelegate: class {
    func didTapShare()
}

final class ActivityView: UIView {

    weak var delegate: ActivityViewDelegate?

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

    private let shareButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "share"), forState: .Normal)

        return button
    }()

    private var heightConstraint: NSLayoutConstraint?

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

        shareButton.addTarget(self, action: #selector(didTapShareButton), forControlEvents: .TouchUpInside)
        stackView.addArrangedSubview(shareButton)

        container.addSubview(stackView)
        scrollview.addSubview(container)
        addSubview(scrollview)

        heightConstraint = container.heightAnchor.constraintEqualToAnchor(heightAnchor)
        heightConstraint?.active = true

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

            //
            container.widthAnchor.constraintEqualToAnchor(scrollview.widthAnchor),
            scrollview.leftAnchor.constraintEqualToAnchor(leftAnchor),
            scrollview.rightAnchor.constraintEqualToAnchor(rightAnchor),
            scrollview.topAnchor.constraintEqualToAnchor(topAnchor),
            scrollview.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
        ])

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
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

    func keyboardWillShow(note: NSNotification) {
        guard let userInfo = note.userInfo else { return }

        guard let (duration, frame, animations) = notification(from: userInfo) else { return }

        heightConstraint?.constant = -frame.height

        UIView.animateWithDuration(duration, delay: 0, options: animations, animations: {
            self.layoutIfNeeded()
            self.scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        }, completion: nil)
    }

    func keyboardWillHide(note: NSNotification) {
        guard let userInfo = note.userInfo else { return }

        guard let (duration, _, animations) = notification(from: userInfo) else { return }

        heightConstraint?.constant = 0

        UIView.animateWithDuration(duration, delay: 0, options: animations, animations: {
            self.layoutIfNeeded()
            self.scrollview.contentInset = UIEdgeInsetsZero
        }, completion: nil)
    }

    func keyboardWillChange(note: NSNotification) {
        guard let userInfo = note.userInfo else { return }

        guard let (duration, frame, animations) = notification(from: userInfo) else { return }

        UIView.animateWithDuration(duration, delay: 0, options: animations, animations: {
            self.scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        }, completion: nil)
    }

    func didTapShareButton() {
        delegate?.didTapShare()
    }
}

typealias KeyboardInfo = (NSTimeInterval, CGRect, UIViewAnimationOptions)
func notification(from userInfo: [NSObject: AnyObject]) ->  KeyboardInfo? {
    guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return nil }
    guard let animationKey = userInfo[UIKeyboardAnimationCurveUserInfoKey] else { return nil }

    let animationOptions = UIViewAnimationOptions(rawValue: UInt(animationKey.integerValue << 16))

    guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()  else { return nil }

    return (duration as NSTimeInterval, keyboardFrame, animationOptions)
}

extension ActivityView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
