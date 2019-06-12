//
//  qrCodeGenerator.swift
//  AvaBuddies
//
//  Created by simon heij on 09/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import UIKit

class QRCodeGenerator {

    func generateQRCode(from data: Data) -> UIImage? {
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
}
