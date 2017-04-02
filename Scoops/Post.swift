//
//  Post.swift
//  Scoops
//
//  Created by David Cava Jimenez on 31/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

struct Post {
    
    
    var title : String
    var author: String
    var photo : String
    var text : String
    
    
    init(withTitle title: String,
         author: String,
         photo: String,
         text: String) {
        
        self.title = title
        self.author = author
        self.photo = photo
        self.text = text
        
    }
    
    
    
}


