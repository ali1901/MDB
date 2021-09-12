//
//  CollectionViewCell.swift
//  MDB
//
//  Created by Ali Safari on 9/1/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var highLightView: UIView!
    
    
    override var isHighlighted: Bool {
      didSet {
        highLightView.isHidden = !isHighlighted
      }
    }
    
    override var isSelected: Bool {
        didSet {
            highLightView.isHidden = !isSelected
        }
    }
    
}
