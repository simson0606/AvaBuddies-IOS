//
//  SvgFileLoader.swift
//  AvaBuddies
//
//  Created by simon heij on 19/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import UIKit
import SVGKit

class SvgFileLoader {
    
    public static func getUIImageFrom(data : Data, size: CGSize) -> UIImage {
        let receivedIcon: SVGKImage = SVGKImage(data: data)
        receivedIcon.scaleToFit(inside: size)
    
        return receivedIcon.uiImage
    }
    
    public static func getUIImageFrom(resource: ResourceFile,  size: CGSize) -> UIImage {
        return getUIImageFrom(data: FileLoader.getDataFrom(resource: resource)!, size: size)
    }
}
