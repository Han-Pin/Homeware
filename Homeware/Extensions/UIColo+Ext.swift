//
//  UIColo+Ext.swift
//  Homeware
//
//  Created by Han-Pin on 2020/8/31.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
    }
}
