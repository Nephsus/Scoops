//
//  UpdateReviewsInteractor.swift
//  Scoops
//
//  Created by itecban itecban on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation


public class UpdateReviewsInteractor{
    
    public func execute(WithKey key : String,
                        ratingValue : CGFloat,
                        WithCompletionBlock finish: @escaping ( ()  -> Void ) ) ->  Void {
        
        FireBaseManagerApiImpl().updateReviews(withKey: key, RatingValue: ratingValue, success: finish)
    
    }
}
