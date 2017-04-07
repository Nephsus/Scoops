//
//  GetUserPosts.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation



public class GetUserPostsInteractor{
    
    public func execute(withUsercode userCode: String,
                        finish: @escaping ( ([Post], [Post])  -> Void ) ) ->  Void {
        
        var ModelPosts = [Post]()
        var ModelPostsPublish = [Post]()
        
        
        FireBaseManagerApiImpl().getUserPosts(withUsercode: userCode) { (key, dict, count) in
            
            if count == 0 {
                 ModelPosts = [Post]()
                 ModelPostsPublish = [Post]()
            
            }
            
            if let publish = dict["isPublish"] as! Bool? {
                
                if !publish {
                    ModelPosts.append( Post(withKey: key,
                                                 title: dict["Titulo"] as! String,
                                                 author: dict["Autor"] as! String,
                                                 photo: dict["Foto"] as! String,
                                                 text: dict["Texto"] as! String,
                                                 publishDate: dict["publishDate"] as! Int,
                                                 isPublish: publish,
                                                 rating: dict["Rating"] as! Int,
                                                 totalRating: dict["TotalRatings"] as! Int))
                }else{
                    ModelPostsPublish.append( Post(withKey: key,
                                                        title: dict["Titulo"] as! String,
                                                        author: dict["Autor"] as! String,
                                                        photo: dict["Foto"] as! String,
                                                        text: dict["Texto"] as! String,
                                                        publishDate: dict["publishDate"] as! Int,
                                                        isPublish: publish,
                                                        rating: dict["Rating"] as! Int,
                                                        totalRating: dict["TotalRatings"] as! Int))
                }
            }else{
                    ModelPosts.append( Post(withKey: key,
                                             title: dict["Titulo"] as! String,
                                             author: dict["Autor"] as! String,
                                             photo: dict["Foto"] as! String,
                                             text: dict["Texto"] as! String,
                                             publishDate: dict["publishDate"] as! Int,
                                             isPublish: false,
                                             rating: dict["Rating"] as! Int,
                                             totalRating: dict["TotalRatings"] as! Int))
                
            }
            
            
            finish( ModelPosts, ModelPostsPublish )
        }
    }

}
