//
//  IMyPostCell.swift
//  Scoops
//
//  Created by David Cava Jimenez on 5/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation



protocol IMyPostCell: class {
    
    func tapOnCoverPost(withPost post: Post)
    func publishPost(withPost post: Post)
 
}
