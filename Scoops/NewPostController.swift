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
import AARatingBar

enum ModeWorkPostController {

    case editable
    case readable

}


class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var txtTitle: UITextField!
    
    
    @IBOutlet weak var txtBody: UITextView!
    
    
    
    @IBOutlet weak var status: UISwitch!
    
    
    @IBOutlet weak var btnNewPost: UIButton!
    
   
    let userEmail : String = "i02cajid@gmail.com"


    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var ratingBar: AARatingBar!
    
    
    @IBOutlet weak var lbPublishStatus: UILabel!
    
    
    
    @IBOutlet weak var lbValoracion: UILabel!
    
    var mode : ModeWorkPostController = .editable
    
    var postSelected  : Post!
    
    var hasImage : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        
        
        if  mode == .readable{
            self.txtTitle.isUserInteractionEnabled = false
            self.txtBody.isUserInteractionEnabled = false
            self.status.isHidden = true
            self.btnNewPost.setTitle( "Valorar" , for: .normal )
            self.txtTitle.text =  postSelected.title
            self.txtBody.text =  postSelected.text
           
        }else{
            lbValoracion.isHidden = true
            ratingBar.isHidden = true
        }
        
        status.addTarget(self, action: #selector(self.stateChanged(switchState:)), for: UIControlEvents.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    
    func stateChanged(switchState: UISwitch) {
        if status.isOn {
            lbPublishStatus.text = "Publicar Automáticamente"
        } else {
            lbPublishStatus.text = "Publicar Manualmente"
        }
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
        
        let spinner = JHSpinnerView.showDeterminiteSpinnerOnView(self.view)
        spinner.progress = 0.0
        spinner.tintColor = UIColor(hex: "#288CFB")
        
        view.addSubview(spinner)
       
        
        if  mode != .readable{ //Alta nuevo post
            
            InsertPostInteractor().execute(WithUserCode: "i02cajid@gmail.com",
                                           image    : imageView.image!,
                                           title    : self.txtTitle.text!,
                                           body     :  self.txtBody.text!,
                                           isPublish: status.isOn,
                                           WithCompletionBlock: {
                                            spinner.dismiss()
                                            let _ = self.navigationController?.popViewController(animated: true)
            })
            
            
        }else{ //Valorar

            
            UpdateReviewsInteractor().execute(WithKey: postSelected.key,
                                              ratingValue: self.ratingBar.value, WithCompletionBlock: {
                                                spinner.dismiss()
                                                let _ = self.navigationController?.popViewController(animated: true)
            })

        
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
            
            
            hasImage = true
            
            DispatchQueue.main.async {
                self.imageView.contentMode = .scaleToFill
                self.imageView.image = pickedImage.resizedImage(screenSize, interpolationQuality: CGInterpolationQuality.medium)
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}



