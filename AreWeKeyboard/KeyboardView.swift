//
//  KeyboardView.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-09.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import UIKit

struct Activity {
    let url: NSURL
}

final class ActivityCell: UICollectionViewCell {

    static let reuseIdentifier = "ActivityCell"

    let activityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(activityImageView)

        backgroundColor = .blackColor()

        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            activityImageView.topAnchor.constraintEqualToAnchor(topAnchor),
            activityImageView.leftAnchor.constraintEqualToAnchor(leftAnchor),
            activityImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            activityImageView.rightAnchor.constraintEqualToAnchor(rightAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

final class NextKeyboardCell: UICollectionViewCell {

    static let reuseIdentifier = "NextKeyboardCell"

    private let nextKeyboardLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFontForTextStyle(UIFontTextStyleCallout)
        label.textColor = .awSunYellowColor()
        label.text = NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button").uppercaseString
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .blackColor()
        contentView.addSubview(nextKeyboardLabel)

        NSLayoutConstraint.activateConstraints([
            nextKeyboardLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            nextKeyboardLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol KeyboardViewDelegate: class {
    func didTapNextKeyboard()
    func didSelect(activity activity: Activity)
}

final class KeyboardView: UIView {
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        return layout
    }()
    private let collectionView: UICollectionView

    private let activities: [Activity]

    weak var delegate: KeyboardViewDelegate?

    init(activities: [Activity]) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.activities = activities

        super.init(frame: .zero)

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(NextKeyboardCell.self, forCellWithReuseIdentifier: NextKeyboardCell.reuseIdentifier)
        collectionView.registerClass(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .whiteColor()
        collectionView.contentInset = UIEdgeInsets(
            top: layout.minimumLineSpacing,
            left: layout.minimumInteritemSpacing,
            bottom: layout.minimumLineSpacing,
            right: layout.minimumInteritemSpacing
        )

        NSLayoutConstraint.activateConstraints([
            collectionView.topAnchor.constraintEqualToAnchor(topAnchor),
            collectionView.leftAnchor.constraintEqualToAnchor(leftAnchor),
            collectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            collectionView.rightAnchor.constraintEqualToAnchor(rightAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = (frame.width - layout.minimumInteritemSpacing * 3) / 2
        layout.itemSize = CGSize(width: width, height: width * 3 / 4)
    }
}

extension KeyboardView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + activities.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier(NextKeyboardCell.reuseIdentifier, forIndexPath: indexPath)
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ActivityCell.reuseIdentifier, forIndexPath: indexPath) as! ActivityCell
        cell.activityImageView.image = UIImage(contentsOfFile: activities[indexPath.row - 1].url.path!)

        return cell
    }
}

extension KeyboardView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.didTapNextKeyboard()
        } else {
            delegate?.didSelect(activity: activities[indexPath.row - 1])
        }
    }
}

