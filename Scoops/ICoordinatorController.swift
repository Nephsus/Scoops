//
//  ICoordinatorController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 31/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation



protocol ICoordinatorController {
    
    var didLoadPosts: (Dictionary<String,AnyObject>) -> Void {get set}
    
}
