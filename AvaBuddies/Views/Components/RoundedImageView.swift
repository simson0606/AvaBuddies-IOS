//
//  RoundedImageView.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//
import UIKit

class RoundedImageView: UIImageView {
    
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
        bounds = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.height, height: bounds.height)
        //assert(bounds.height == bounds.width, "The aspect ratio isn't 1/1. You can never round this image view!")
        layer.cornerRadius = bounds.height / 2
    }
}
