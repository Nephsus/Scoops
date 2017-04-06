//
//  ViewController.swift
//  Posts
//
//  Created by David Cava Jimenez on 28/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,ICoordinatorController , IReadPost {
    
    
    
    @IBOutlet weak var collectionPost: UICollectionView!
    
  
    var didLoadPosts: (Dictionary<String,AnyObject>) -> Void = { _ in }
   
    var coordinator : ICoordinator!
   
    var ModelPosts = [Post] ()
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Inicializo el coordinaro
       // var self2 = self
        //coordinator  = PostsCoordinator(withController: &self2)
        
        
        let nib = UINib(nibName: "PostViewCell", bundle: nil)
        
        self.collectionPost.register(nib, forCellWithReuseIdentifier: "PostViewCell")
        
        
        
        self.title="Scoops"
        
        self.navigationController?
            .navigationBar
            .titleTextAttributes=[NSForegroundColorAttributeName: UIColor(hex: "#288CFB")]
        
        self.navigationController?
            .navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?
            .navigationBar.layer.shadowOffset = CGSize(width: CGFloat(2), height: CGFloat(2))
        self.navigationController?
            .navigationBar.layer.shadowRadius = 4.0;
        self.navigationController?
            .navigationBar.layer.shadowOpacity = 1.0;

        
        let postRef = FIRDatabase.database().reference()
        let _ = postRef.observe(FIRDataEventType.value, with: { [weak self] (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
          
            guard let `self` = self else {
                return
            }
            
            
            self.ModelPosts = [Post]()
            
            let posts  = postDict["Posts"] as! Dictionary<String , AnyObject>
            
            for (key, value) in posts{
                
                print(key)
                
                self.ModelPosts.append( Post(withKey: key,
                                             title: value["Titulo"] as! String,
                                             author: value["Autor"] as! String,
                                             photo: value["Foto"] as! String,
                                             text: value["Texto"] as! String,
                                             publishDate: value["publishDate"] as! Int,
                                             rating: value["Rating"] as! Int,
                                             totalRating: value["TotalRatings"] as! Int
                                         ))
            }
            
            DispatchQueue.main.async {
                self.collectionPost.reloadData()
            }
        })
        
     

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func performReadPost(withPost post: Post ){
        
        
       
        self.performSegue(withIdentifier: "readPost", sender: post)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "readPost"{
         
           guard let post = sender as? Post else {
               return
            }
            
        let vc = segue.destination as! NewPostController
            vc.mode = .readable
            vc.postSelected = post
            
        
        }
        
        
    }


}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ModelPosts.isEmpty{
            return 0
        }
    return ModelPosts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        
        cell.layer.borderColor = UIColor(hex: "#288CFB").cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        cell.layer.shadowRadius = 4.0;
        cell.layer.shadowOpacity = 1.0;
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        
        cell.createCell(post: ModelPosts[indexPath.row])
        
        cell.delegate = self
        
        
        //cell.lbAuthor.text =   ModelPosts[indexPath.row].author
        
        
        return cell
    }
    
    
    
}

