//
//  RoundedCornersView.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/25/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
