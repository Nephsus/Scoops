//
//  InsertPostInteractor.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation



public class InsertPostInteractor{
    
    public func execute(WithUserCode userCode : String,
                        image : UIImage,
                        title : String,
                        body  : String,
                        isPublish : Bool,
                        WithCompletionBlock finish: @escaping ( ()  -> Void ) ) ->  Void {
        
        FireBaseManagerApiImpl().insertPost(
                WithUserCode: userCode, image: image, title: title, body: body, isPublish: isPublish, success: finish)
    }
}
