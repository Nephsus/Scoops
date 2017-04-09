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
    let storageRef =  FIRStorage.storage().reference(forURL: "gs://scoops-7c457.appspot.com")


    func getAllPosts(withCompletionBlock success: @escaping successPost ) ->  Void {

        let _ = postRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            guard let postDict = snapshot.value as? [String : AnyObject] else {
            
              return
            }
            
           // let postDict = snapshot.value as! [String : AnyObject]
            
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
    
    
   
    
    func insertPost(WithUserCode usercode : String, imagen: UIImage?,
                    title: String,
                    body: String,
                    isPublish: Bool,
                    success: @escaping (()-> Void)) -> Void {
        
 
        if let imagen = imagen{
        
            //Se ha subido una imagen
            // Cargamos la imagen en memoria
            let data: NSData = (UIImagePNGRepresentation( imagen ) as NSData?)!
            // Create a reference to the file you want to upload
            let idString =  UUID().uuidString
            let riversRef = storageRef.child("images/\(usercode)/\(idString)")
            
            _ = riversRef.put(data as Data, metadata: nil) { metadata, error in
                if (error != nil) {
                    print(error ?? "")
                } else {
                   
                    self.addNewPost(WithUserCode: usercode,
                                    metadata: metadata,
                                    title: title,
                                    body: body,
                                    isPublish: isPublish,
                                    success: success)
                }
        
            }

        } else{
                    self.addNewPost(WithUserCode: usercode,
                            metadata: nil,
                            title: title,
                            body: body,
                            isPublish: isPublish,
                            success: success)
        
            }

    }
    
    
     func addNewPost(WithUserCode usercode : String, metadata : FIRStorageMetadata?,
                                title: String,
                                body: String,
                                isPublish: Bool,
                                success: @escaping (()-> Void)) -> Void{
    
        // Recogo la url de la imagen subida si la hubiera
        
        var emptyURL = ""
        if let _ = metadata, let downloadURL = metadata!.downloadURL(){
            emptyURL = downloadURL.absoluteString
        }
        let postRef = FIRDatabase.database().reference()
        
        let key = postRef.child("Posts").childByAutoId().key
        
        
        let newPost = ["Autor" : RootCoordinator.userInfo?.userName ?? "",
                       "Foto" : emptyURL,
                       "Titulo" : title,
                       "Texto" : body,
                       "Property" : usercode,
                       "publishDate" : [".sv": "timestamp"] ,
                       "isPublish" : isPublish,
                       "Rating": 0 ,
                       "TotalRatings" : 0] as [String : Any]
        
        let registerFB = ["\(key)" : newPost]
        
        
        postRef.child("Posts").updateChildValues(registerFB, withCompletionBlock: { (error, reference) in
            success()
        })
        
    
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





