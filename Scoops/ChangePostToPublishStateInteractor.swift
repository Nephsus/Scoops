//
//  ChangePostToPublishState.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

public class ChangePostToPublishState{

    public func execute(WithKey key : String,
                        WithCompletionBlock finish: @escaping ( ()  -> Void ) ) ->  Void {
    
        FireBaseManagerApiImpl().postPublish(withKey: key) {
                    finish()
        }

    }
}
