//
//  UIColor+Hexadecimal.swift
//  Posts
//
//  Created by David Cava Jimenez on 29/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit


extension UIColor{

    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        /*if (cString.characters.count != 6) {
            return UIColor.gray
        }*/
        
        let rString = cString.substring(to: cString.index(cString.startIndex, offsetBy: 2))
        let gString = cString.substring(with: cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4))
        let bString = cString.substring(with: cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }



}
