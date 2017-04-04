//
//  NewPostController.swift
//  Scoops
//
//  Created by itecban itecban on 3/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import JHSpinner

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var txtTitle: UITextField!
    
    
    @IBOutlet weak var txtBody: UITextView!
    
    
    
    @IBOutlet weak var status: UISwitch!
    
    
    @IBOutlet weak var btnNewPost: UIButton!
    
   
    let userEmail : String = "i02cajid@gmail.com"


    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        
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


    @IBAction func cameraButton(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    @IBAction func btnNewPost(_ sender: Any) {
        
        
       
        // Get a reference to the storage service, using the default Firebase App
        
        
        let spinner = JHSpinnerView.showDeterminiteSpinnerOnView(self.view)
        spinner.progress = 0.0
        spinner.tintColor = UIColor(hex: "#288CFB")
        
        view.addSubview(spinner)
        
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://scoops-7c457.appspot.com")
        
        
        
        
        // Data in memory
        let data: NSData = (UIImagePNGRepresentation(imageView.image!) as NSData?)!
        // Create a reference to the file you want to upload
        let idString =  UUID().uuidString
        let riversRef = storageRef.child("images/\(userEmail)/\(idString)")
        

        _ = riversRef.put(data as Data, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
                
                let postRef = FIRDatabase.database().reference()
                
                let key = postRef.child("Posts").childByAutoId().key
                
                
              
                
                let newPost = ["Autor" : "yo mismo",
                               "Foto" : downloadURL?.absoluteString ?? "",
                               "Titulo" : self.txtTitle.text!,
                               "Texto" : self.txtBody.text!,
                               "Property" : self.userEmail,
                               "publishDate" : [".sv": "timestamp"] ,
                               "IsPublish" : false] as [String : Any]
                
                let registerFB = ["\(key)" : newPost]
                
                postRef.child("Posts").updateChildValues(registerFB, withCompletionBlock: { [weak self] (error, FBDataReference) in
                    
                    print("\(error)")
                    spinner.dismiss()
                    
                    let _ = self?.navigationController?.popViewController(animated: true)
                    
                })
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
        //Intentamos optimizar la imagen porque
        //es demasiado grande y consume mucha memoria
        
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        
        let screenSize : CGSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale )
        
        
        DispatchQueue.main.async {
            self.imageView.contentMode = .scaleToFill
            self.imageView.image = pickedImage.resizedImage(screenSize, interpolationQuality: CGInterpolationQuality.medium)
            
        }
        
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}



