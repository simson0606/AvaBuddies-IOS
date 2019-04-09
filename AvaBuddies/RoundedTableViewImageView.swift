//
//  RoundedImageView.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//
import UIKit

class RoundedTableViewImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        bounds = CGRect(x: bounds.minX, y: bounds.minY, width: 43, height: 43)
        layer.cornerRadius = bounds.height / 2
    }
}
