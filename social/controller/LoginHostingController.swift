//
//  HostingController.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Hosting controller for login view
class LoginHostingController: UIHostingController<LoginView> {
    
    /// Override preferredStatusBarStyle to set status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        // Set the status bar to the light version
        return .lightContent
    }
}
