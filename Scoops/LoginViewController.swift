//
//  LoginViewController.swift
//  Scoops
//
//  Created by David Cava Jimenez on 7/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
      var handle: FIRAuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener({ [weak self] (auth, user) in
            print("El mail del usuario logado es \(String(describing: user?.email))")
         
            guard let `self` = self  else{
              return
            
            }
            if user !=  nil {
                RootCoordinator.setUser(UserInfor: UserInfo(userName: (user?.displayName)!, email: (user?.email)!) )
                self.performSegue(withIdentifier: "successAuthenticate", sender: self)
                 FIRAuth.auth()?.removeStateDidChangeListener( self.handle )
            }
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnLogin(_ sender: Any) {
        
         GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        
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
