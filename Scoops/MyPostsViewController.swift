//
//  MyPostsViewController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase
import JHSpinner

class MyPostsViewController: UIViewController, IMyPostCell {
    
    var ModelPosts : [Post]!
    var ModelPostsPublish : [Post]!
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var PostsPublish: UICollectionView!
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MyPostsViewCell", bundle: nil)
        
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MyPostsViewCell")
        
        self.PostsPublish.register(nib, forCellWithReuseIdentifier: "MyPostsViewCell")
        
        
        loadPosts()
    
    }
    
    
    func loadPosts(){
        self.ModelPosts = [Post]()
        self.ModelPostsPublish = [Post]()
        
        self.collectionView.reloadData()
        self.PostsPublish.reloadData()
        
        GetUserPostsInteractor().execute(withUsercode: "i02cajid@gmail.com") { (posts, postsPublish) in
            
            self.ModelPosts = posts
            self.ModelPostsPublish = postsPublish
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.PostsPublish.reloadData()
            }
            
        }
    
    }

    
    
    //MARK: Navigation
    func performReadPost(withPost post: Post ){
        self.performSegue(withIdentifier: "AddPost", sender: post)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddPost"{
            
            guard let post = sender as? Post else {
                return
            }
            
            let vc = segue.destination as! NewPostController
            vc.mode = .readable
            vc.postSelected = post
            
            
        }
        
        
    }
    
    
    func tapOnCoverPost(withPost post: Post){
    
    
    }

    
    func publishPost(withPost post: Post){
        
        let spinner = JHSpinnerView.showDeterminiteSpinnerOnView(self.view)
        spinner.progress = 0.0
        spinner.tintColor = UIColor(hex: "#288CFB")
        
        view.addSubview(spinner)
        
        
        ChangePostToPublishState().execute(WithKey: post.key) {
            spinner.dismiss()
        }
    
       
    
    }


}


extension MyPostsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.collectionView){
            if ModelPosts == nil || ModelPosts.isEmpty{
            return 0
            }
            return ModelPosts.count
        }else{
            if ModelPostsPublish == nil || ModelPostsPublish.isEmpty{
                return 0
            }
            return ModelPostsPublish.count
        
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostsViewCell", for: indexPath) as! MyPostsViewCell

        
        
        
        
        cell.delegate = self
        
        if(collectionView == self.collectionView){
                cell.createCell(post: ModelPosts[indexPath.row])
        }else{
                cell.createCell(post: ModelPostsPublish[indexPath.row])

        }

        return cell
    }
    
    
    
}


