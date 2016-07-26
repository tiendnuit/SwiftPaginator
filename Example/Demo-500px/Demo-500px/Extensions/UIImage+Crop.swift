//
//  UIImage+Crop.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/24/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
