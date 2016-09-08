//
//  ColorPicker.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import UIKit

final class ColorPickerItem: UICollectionViewCell {
    var color: UIColor = .blackColor() {
        didSet {
            colorView.backgroundColor = color
        }
    }

    private let colorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.borderColor = UIColor.whiteColor().CGColor
        colorView.layer.borderWidth = 1
        colorView.layer.cornerRadius = 5
        contentView.addSubview(colorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        colorView.frame = bounds
    }
}

final class ColorPicker: UIView {

    private let colors: [UIColor] = [
        .awSunYellowColor(),
        .awScarletColor(),
        .awSquashColor(),
        .awDarkGrassGreenColor(),
        .awDarkSkyBlueColor(),
        .awVioletColor(),
        .awLightSageColor()
    ]
    private let collectionView: UICollectionView
    private let layout: UICollectionViewFlowLayout

    typealias ColorChangedCallback = (UIColor) -> Void
    private let callback: ColorChangedCallback

    init(callback: ColorChangedCallback) {
        self.layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        self.callback = callback
        
        super.init(frame: .zero)

        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(ColorPickerItem.self, forCellWithReuseIdentifier: "ColorPickerItem")
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = bounds
        layout.itemSize = CGSize(width: frame.height * 16 / 9 - 10, height: frame.height - 10)
    }
}

extension ColorPicker: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorPickerItem", forIndexPath: indexPath) as! ColorPickerItem
        cell.color = colors[indexPath.row]

        return cell
    }
}

extension ColorPicker: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard (0..<colors.count).contains(indexPath.row) else { return }

        callback(colors[indexPath.row])
    }
}