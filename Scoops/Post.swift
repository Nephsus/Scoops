//
//  Post.swift
//  Scoops
//
//  Created by David Cava Jimenez on 31/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

struct Post {
    
    var key : String
    var title : String
    var author: String
    var photo : String
    var imagePost : AsyncData?
    var text : String
    var publishDate : Int
    var publishDateFormat : String {
        get{
            
            let myDate = Date(timeIntervalSince1970: TimeInterval(publishDate / 1000) )
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let time = dateFormatter.string( from: myDate )
            
              return  time
        }
    }
    var isPublish: Bool
   
    init(withKey key: String,
         title: String,
         author: String,
         photo: String,
         text: String,
         publishDate: Int,
         isPublish:Bool) {
        
        self.key = key
        self.title = title
        self.author = author
        self.photo = photo
        self.text = text
        self.publishDate = publishDate
        self.isPublish = isPublish
        
        imagePost = AsyncData(url: URL(string: photo )!, defaultData: PostViewCell.noImageData!)
        
    }

    
    
    
     init(withKey key: String,
          title: String,
          author: String,
          photo: String,
          text: String,
          publishDate: Int) {
        
        self.key = key
        self.title = title
        self.author = author
        self.photo = photo
        self.text = text
        self.publishDate = publishDate
        self.isPublish = false
        
        imagePost = AsyncData(url: URL(string: photo )!, defaultData: PostViewCell.noImageData!)
    }
    
    
    
    
    
    
}


