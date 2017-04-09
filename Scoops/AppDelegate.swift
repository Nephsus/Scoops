//
//  AppDelegate.swift
//  Posts
//
//  Created by David Cava Jimenez on 28/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,  GIDSignInDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Método que inicializa FireBase en la app y GoogleSign
        RootCoordinator.Initialize(appDelegate: self)
                
        return true
    }

    func application(_ application: UIApplication,
                     open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    //MARK: Authentication GoogleSign
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
     {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authForFireBase = user.authentication else {
            return
        }
        
        let creditials = FIRGoogleAuthProvider.credential(withIDToken: authForFireBase.idToken, accessToken: authForFireBase.accessToken)
        
        FIRAuth.auth()?.signIn(with: creditials, completion: { (user, error) in
            if let _ = error {
                print("Error")
                return
            }
            print(user?.displayName ?? "")
            
            RootCoordinator.setUser(UserInfor: UserInfo(userName: (user?.displayName)!, email: (user?.email)!) )
            
            
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        RootCoordinator.logout()
        
    }
    
    

}


