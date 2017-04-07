//
//  FireBaseManagerApi.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation
import Firebase



public typealias successPost = ( Dictionary<String , AnyObject> ) -> Void

public typealias successPostUser = ( String, Dictionary<String , AnyObject>, Int ) -> Void

public class FireBaseManagerApiImpl{
    
    let postRef = FIRDatabase.database().reference()
    


    func getAllPosts(withCompletionBlock success: @escaping successPost ) ->  Void {

        let _ = postRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let postDict = snapshot.value as! [String : AnyObject]
            
            success( postDict["Posts"] as! Dictionary<String , AnyObject> )

            })

    }
    
    
    func getUserPosts(withUsercode  usercode: String, success: @escaping successPostUser) ->  Void {
        
        
        postRef.child("Posts").queryOrdered(byChild: "Property")
            .queryEqual(toValue: usercode)
            .observe(.value, with: { snapshot in
                print( snapshot )
               
                var count = 0
                
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    print(child)
                    let dict = child.value as! Dictionary<String , AnyObject>
                    
                    print("\(dict["Autor"])")
                
                    success(child.key, dict, count)
                    count = count + 1
                }
                
                                
                
            } )
    }
    
    func postPublish(withKey key : String,  success: @escaping (()-> Void)) -> Void {
       
        postRef.child("Posts/\(key)")
            .updateChildValues(["isPublish" : true])
                                {(error, reference) in
            
                                    success()
            
                                }

    }
    
    func insertPost(WithUserCode usercode : String,
                    image: UIImage,
                    title: String,
                    body: String,
                    isPublish: Bool,
                    success: @escaping (()-> Void)) -> Void {
        let storage = FIRStorage.storage()
 
        let storageRef = storage.reference(forURL: "gs://scoops-7c457.appspot.com")

        
        // Data in memory
        let data: NSData = (UIImagePNGRepresentation( image ) as NSData?)!
        // Create a reference to the file you want to upload
        let idString =  UUID().uuidString
        let riversRef = storageRef.child("images/\(usercode)/\(idString)")
        
        
        _ = riversRef.put(data as Data, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error ?? "")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
                
                let postRef = FIRDatabase.database().reference()
                
                let key = postRef.child("Posts").childByAutoId().key

                
                let newPost = ["Autor" : "yo mismo",
                               "Foto" : downloadURL?.absoluteString ?? "",
                               "Titulo" : title,
                               "Texto" : body,
                               "Property" : usercode,
                               "publishDate" : [".sv": "timestamp"] ,
                               "IsPublish" : isPublish,
                               "Rating": 0 ,
                               "TotalRatings" : 0] as [String : Any]
                
                let registerFB = ["\(key)" : newPost]
                
                
                postRef.child("Posts").updateChildValues(registerFB, withCompletionBlock: { (error, reference) in
                    success()
                })
                
            }
        }

    }
    
    func updateReviews(withKey key : String,
                       RatingValue value: CGFloat,
                       success: @escaping (()-> Void)) -> Void {
        
        
        postRef.child("Posts/\(key)")
            .runTransactionBlock({ (data) -> FIRTransactionResult in
                
                var p = data.value as! Dictionary<String,AnyObject>
                var ratings = p["Rating"] as! Int
                
                ratings = ratings + Int(value)
                
                p["Rating"] = ratings as AnyObject?
                
                p["TotalRatings"] = ((p["TotalRatings"] as! Int) + 1) as AnyObject?
                
                data.value = p
                
                return FIRTransactionResult.success(withValue: data)
                
            }, andCompletionBlock: { (error, bool, snapshot) in
                success()
                
            })

    }


}





