//
//  MyPostsViewCell.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit

class MyPostsViewCell: UICollectionViewCell {
    
    weak var delegate : IMyPostCell?
    
    var post: Post!
    
    @IBOutlet weak var imagePost: UIImageView!
    

    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var publishButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func createCell( post: Post, isPublish: Bool) -> Void {
        
        self.post = post

        if isPublish {
           publishButton.isHidden = true
        }
        syncLookAndFeel()
        syncModelView()
        
        post.imagePost?.delegate = self
        
    }
    
    
    func syncLookAndFeel() -> Void {
        self.layer.borderColor = UIColor(hex: "#288CFB").cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.layer.shadowRadius = 4.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
    }
    
    
    
    func syncModelView(  ) {

        DispatchQueue.main.async {
            self.lbTitle.text = self.post.title
            self.imagePost.image = UIImage(data: (self.post.imagePost?.data)!)
            
            UIView.transition(with: self.imagePost,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: {
                                
                                
                                self.imagePost.image =  UIImage(data: (self.post.imagePost?.data)!)
                                self.imagePost.contentMode = .scaleToFill
                                
                                
            }, completion: nil)
            
            
        }
    }

    
    
    @IBAction func publishButton(_ sender: Any) {
        
        self.delegate?.publishPost(withPost: self.post)
        
    }
    
}

//MARK: - AsyncDataDelegate
extension MyPostsViewCell: AsyncDataDelegate{
    
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

