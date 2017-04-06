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
    var rating: Int
    var totalRating: Int
    
    var ratingValoration : CGFloat {
        get {
              return CGFloat(rating) / CGFloat(totalRating)
        
        }
    
    }
   
    init(withKey key: String,
         title: String,
         author: String,
         photo: String,
         text: String,
         publishDate: Int,
         isPublish:Bool,
         rating: Int,
         totalRating: Int) {
        
        self.key = key
        self.title = title
        self.author = author
        self.photo = photo
        self.text = text
        self.publishDate = publishDate
        self.isPublish = isPublish
        self.rating = rating
        self.totalRating = totalRating
        
        imagePost = AsyncData(url: URL(string: photo )!, defaultData: PostViewCell.noImageData!)
        
    }

    
    
    
     init(withKey key: String,
          title: String,
          author: String,
          photo: String,
          text: String,
          publishDate: Int,
          rating: Int,
          totalRating: Int) {
        
        self.key = key
        self.title = title
        self.author = author
        self.photo = photo
        self.text = text
        self.publishDate = publishDate
        self.isPublish = false
        self.rating = rating
        self.totalRating = totalRating
        
        imagePost = AsyncData(url: URL(string: photo )!, defaultData: PostViewCell.noImageData!)
    }
    
    
    
    
    
    
}


