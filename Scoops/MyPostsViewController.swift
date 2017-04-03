//
//  MyPostsViewController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase

class MyPostsViewController: UIViewController {
    
     var ModelPosts = [Post] ()
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "PostViewCell", bundle: nil)
        
        self.collectionView.register(nib, forCellWithReuseIdentifier: "PostViewCell")
        
        let myPostRef = FIRDatabase.database().reference()
        
        
        myPostRef.child("Posts").queryOrdered(byChild: "Property")
            .queryEqual(toValue: "i02cajid@gmail.com")
            .observe(.value, with: { snapshot in
                 print( snapshot )
               // snapshot
               
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let dict = child.value as! [String : String]
                    
                    print("\(dict["Autor"])")
                    
                    self.ModelPosts.append( Post(withTitle: dict["Titulo"]!,
                                                 author: dict["Autor"]!,
                                                 photo: dict["Foto"]!,
                                                 text: dict["Texto"]!))
                

                
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
        
            
        } )
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MyPostsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        
       // cell.lbAuthor.text =   ModelPosts[indexPath.row].author
        
        
        return cell
    }
    
    
    
}


