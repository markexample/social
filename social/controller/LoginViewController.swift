//
//  ViewController.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import FacebookLogin
import FacebookCore
import FirebaseAuth

/// View controller used for representing a UIViewController used on Facebook login method
struct LoginViewController: UIViewControllerRepresentable {
    
    /// Binding string for setting the log in button title
    @Binding var buttonTitle: String
    
    /// Button title shown when logging into Firebase
    private let LOGGING_IN = "Logging In..."
    
    /// Console message when user cancelled
    private let USER_CANCELLED_LOGIN = "User cancelled login."
    
    /// Make view controller
    /// - Parameter context: Context for view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<LoginViewController>) -> UIViewController {
        
        /// Create the UIViewController
        let vc = UIViewController()
        
        // Prompt logging into Facebook using standard email and public profile permissions
        LoginManager().logIn(permissions: [.email, .publicProfile], viewController: vc) { (loginResult) in
            
            // Dismiss the view controller on result
            vc.dismiss(animated: true, completion: nil)
            
            // Check the login result
            switch(loginResult){
                
            // Case when login has failed
            case .failed(let error):
                
                // Print login error
                print(error)
                
                // Break from switch
                break
                
            // Case when user cancelled login
            case .cancelled:
                
                // Print user cancelled login message
                print(self.USER_CANCELLED_LOGIN)
                
                // Break from switch
                break
                
            // Case when login has succeeded
            case .success(granted: _, declined: _, token: _):
                
                // Set the button title state variable to indicate logging into Firebase
                self.buttonTitle = self.LOGGING_IN
                
                // Create the Firebase credential from the Facebook access token
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                
                // Sign into Firebase with the Firebase credential
                Auth.auth().signIn(with: credential) { (result, error) in
                    
                    // Check if Firebase user is valid
                    if(Auth.auth().currentUser != nil){
                        
                        // Animate login transition for logging in
                        Util.animateLoginTransition(type: .login)
                        
                    }
                }
                break
            }
        }
        return vc
    }
    
    /// Update view controller
    /// - Parameters:
    ///   - uiViewController: View controller
    ///   - context: Context of view controller
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LoginViewController>) {
        
    }
}
