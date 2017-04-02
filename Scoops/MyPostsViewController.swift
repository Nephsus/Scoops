//
//  MyPostsViewController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 2/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit

class MyPostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                  return 0
      
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


