//
//  MyPostsViewController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase

class MyPostsViewController: UIViewController, IReadPost {
    
    var ModelPosts : [Post]!
    var ModelPostsPublish : [Post]!
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var PostsPublish: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MyPostsViewCell", bundle: nil)
        
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MyPostsViewCell")
        
        self.PostsPublish.register(nib, forCellWithReuseIdentifier: "MyPostsViewCell")
        
        let myPostRef = FIRDatabase.database().reference()
        
        
        
        myPostRef.child("Posts").queryOrdered(byChild: "Property")
            .queryEqual(toValue: "i02cajid@gmail.com")
            .observe(.value, with: { snapshot in
                 print( snapshot )
               // snapshot
                self.ModelPosts = [Post] ()
                self.ModelPostsPublish = [Post] ()
               
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let dict = child.value as! Dictionary<String , AnyObject>
                    
                    print("\(dict["Autor"])")
                    
               
                    if let publish = dict["isPublish"] as! Bool? {
                       
                        if !publish {
                            self.ModelPosts.append( Post(withTitle: dict["Titulo"] as! String,
                                                         author: dict["Autor"] as! String,
                                                         photo: dict["Foto"] as! String,
                                                         text: dict["Texto"] as! String,
                                                         publishDate: dict["publishDate"] as! Int,
                                                         isPublish: publish))
                        }else{
                            self.ModelPostsPublish.append( Post(withTitle: dict["Titulo"] as! String,
                                                                author: dict["Autor"] as! String,
                                                                photo: dict["Foto"] as! String,
                                                                text: dict["Texto"] as! String,
                                                                publishDate: dict["publishDate"] as! Int,
                                                                isPublish: publish))
                        }
                        
                    }else{
                        self.ModelPosts.append( Post(withTitle: dict["Titulo"] as! String,
                                                            author: dict["Autor"] as! String,
                                                            photo: dict["Foto"] as! String,
                                                            text: dict["Texto"] as! String,
                                                            publishDate: dict["publishDate"] as! Int,
                                                            isPublish: false))
                    
                    }
                    
                 
                    
                    
                    print("\(self.ModelPosts.count)")

                
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.PostsPublish.reloadData()
                }
        
            
        } )
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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

        
        
        cell.layer.borderColor = UIColor(hex: "#288CFB").cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        cell.layer.shadowRadius = 4.0;
        cell.layer.shadowOpacity = 1.0;
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        
        cell.delegate = self
        
        if(collectionView == self.collectionView){
                cell.createCell(post: ModelPosts[indexPath.row])
        }else{
                cell.createCell(post: ModelPostsPublish[indexPath.row])

        }
        
       // cell.lbAuthor.text =   ModelPosts[indexPath.row].author
        
        
        return cell
    }
    
    
    
}


