//
//  PostViewCell.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import AARatingBar

class PostViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    static let noImageData = UIImagePNGRepresentation (UIImage(named: "noimage.png")!)
    var post : Post!

    @IBOutlet weak var lbAuthor: UILabel!
    
    
    weak var delegate : IReadPost?
    
    
    
    @IBOutlet weak var publishValue: UILabel!
    
    
    @IBOutlet weak var imagePost: UIImageView!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var ratingBar: AARatingBar!
    
    func createCell( post: Post) -> Void {
        
        self.post = post

        syncModelView()
        
        post.imagePost?.delegate = self
        
    }

     func syncModelView(  ) {
        self.ratingBar.value = self.post.ratingValoration
        
        self.ratingBar.draw(ratingBar.frame)
        
        
        DispatchQueue.main.async {
        self.lbAuthor.text = self.post.author
        self.publishValue.text = self.post.publishDateFormat
        self.lbTitle.text = self.post.title
        //self.imagePost.image = UIImage(data: (self.post.imagePost?.data)!)
            
        print( self.ratingBar.value  )
        UIView.transition(with: self.imagePost,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            
                            
                                self.imagePost.image =  UIImage(data: (self.post.imagePost?.data)!)
                                self.imagePost.contentMode = .scaleToFill
                            
                            
        }, completion: nil)
        
        
        }
    }
    
    @IBAction func readMore(_ sender: Any) {
       self.delegate?.performReadPost(withPost: self.post)
    }
    
}


//MARK: - AsyncDataDelegate
extension PostViewCell: AsyncDataDelegate{
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        
       // let notificationName : Notification.Name
        
        
        syncModelView( )
        
    }
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        print("Starting with \(url)")
    }
    
    func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError){
        print("Error loading \(url).\n \(error)")
    }
}
