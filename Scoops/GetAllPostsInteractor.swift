//
//  GetAllPosts.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation


public class GetAllPostsInteractor{

    public func execute(WithCompletionBlock finish: @escaping ( ([Post])  -> Void ) ) ->  Void {

        FireBaseManagerApiImpl().getAllPosts { (posts) in
            
            var ModelPosts = [Post]()
            
            for (key, value) in posts{
                ModelPosts.append( Post(withKey: key,
                                        title: value["Titulo"] as! String,
                                        author: value["Autor"] as! String,
                                        photo: value["Foto"] as! String,
                                        text: value["Texto"] as! String,
                                        publishDate: value["publishDate"] as! Int,
                                        rating: value["Rating"] as! Int,
                                        totalRating: value["TotalRatings"] as! Int))
            }
            finish( ModelPosts )
        }
    }

}
