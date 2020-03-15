//
//  Util.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

/// Utility class for adding functionality
class Util: NSObject {
    
    /// Large size of profile picture on profile view
    static let LARGE_PROFILE_PIC_SIZE = 500
    
    /// Small size of profile picture on lists on home and profile view
    static let SMALL_PROFILE_PIC_SIZE = 200
    
    /// Facebook domain used in Facebook Graph API request
    static let FACEBOOK_DOMAIN = "facebook.com"
    
    /// Endpoint used for the request
    static let FACEBOOK_GRAPH_API_ENDPOINT = "http://graph.facebook.com/"
    
    /// Picture height url paramter
    static let PICTURE_HEIGHT_URL_PARAMETER = "/picture?height="
    
    /// Enumeration type for profile picture quality being high or low
    enum PROFILE_PIC_QUALITY {
        case high
        case low
    }
    
    /// Enumeration type for login transition
    enum LOGIN_TRANSITION_TYPE {
        case login
        case logout
    }
    
    /// Duration for animation on logout transition in seconds
    static let LOGOUT_TRANSITION_DURATION = 0.3
    
    /// Get the safe area of the device
    static func getSafeArea() -> UIEdgeInsets{
        
        // Get the safe area insets from the first key window of UIApplication
        let safeAreaInsets = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets
        
        // Return safe area if valid
        if let safeArea = safeAreaInsets{
            return safeArea
        }
        
        // Otherwise return an empty safe area
        return UIEdgeInsets()
    }
    
    /// Get the profile picture url string based on quality type
    /// - Parameter quality: Quality type of high or low for size of profile picture returned
    static func getProfilePic(quality: PROFILE_PIC_QUALITY)->String{
        
        /// Get the string representation of the integer for the size of the profile picture returned based on quality type
        let qualityString = quality == .high ? LARGE_PROFILE_PIC_SIZE : SMALL_PROFILE_PIC_SIZE
        
        /// String for the facebook user id in url
        var facebookUserId = ""
        
        /// Iterate through the provider data in the Firebase user
        for profile in (Auth.auth().currentUser?.providerData)!{
            
            // If the provider id matches the facebook domain
            if(profile.providerID == FACEBOOK_DOMAIN){
                
                // Set the facebook user id in the url to the profile uid
                facebookUserId = profile.uid
            }
        }
        
        // Return the profile picture url string for profile picture image
        return FACEBOOK_GRAPH_API_ENDPOINT + facebookUserId + PICTURE_HEIGHT_URL_PARAMETER + String(describing: qualityString)
    }
    
    /// Animate the logging in or out transition based on parameter
    /// - Parameter logIn: Boolean for showing transition for logging in or out
    static func animateLoginTransition(type: LOGIN_TRANSITION_TYPE){
        
        let showLoginView = type == .logout
        
        // Get the first window the UIApplication
        let window = UIApplication.shared.windows.first
        
        // Set the root view controller of the window to login or main hosting controller passing
        // in the login view or content view based on the boolean parameter passed in
        window?.rootViewController = showLoginView ? LoginHostingController(rootView: LoginView()) : HostingController(rootView: ContentView())
        
        // Shows the window and makes it the key window
        window?.makeKeyAndVisible()
        
        // Animate the logout transition with a short flip from the left
        UIView.transition(with: window!, duration: LOGOUT_TRANSITION_DURATION, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
}
