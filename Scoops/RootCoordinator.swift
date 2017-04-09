//
//  RootCoordinator.swift
//  Scoops
//
//  Created by David Cava Jimenez on 31/3/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation
import Firebase


struct RootCoordinator  {
    
    static var userInfo: UserInfo? = nil
    

    static func isUserLogged() -> Bool{
    
        if RootCoordinator.userInfo == nil,
             (RootCoordinator.userInfo?.iD ?? "").isEmpty{
              return false
        }
        return true
    }
    
    
    static func setUser(UserInfor userInfo : UserInfo){
        self.userInfo  = userInfo
    }
    
    static func getUserId() ->String?{
        return RootCoordinator.userInfo?.iD
    }
    
    
    static func Initialize( appDelegate: GIDSignInDelegate){
      FIRApp.configure()
      GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
      GIDSignIn.sharedInstance().delegate = appDelegate
        
        if FIRAuth.auth() != nil, FIRAuth.auth()?.currentUser != nil{
            RootCoordinator.setUser(UserInfor: UserInfo(userName: (FIRAuth.auth()?.currentUser?.displayName)!,
                                                        email: (FIRAuth.auth()?.currentUser?.email)!))
        }
        
      

    }
    
    static func logout(){
    
        try! FIRAuth.auth()!.signOut()

    
    }

}


struct  UserInfo {
    var iD : String{
        get {
             return email  //Utilizamos el email como campo identificador
        }
    }
    let userName: String
    let email : String
    
    init(userName : String, email : String) {
        self.userName = userName
        self.email = email
    }
    
}
