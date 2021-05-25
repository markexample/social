//
//  Constants.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Constants used in the app
struct Constants{
    
    /// Firestore collection containing posts for all users
    static let COLLECTION_POSTS = "posts"
    
    /// Size of small profile pictures used in list views
    static let SMALL_PROFILE_PIC_SIZE = CGFloat(50)
    
    /// Background color of main view in pages
    static let PAGE_BACKGROUND_COLOR = Color.white
    
    /// Shadow color used for all shadows
    static let SHADOW_COLOR = Color(red: 17/255, green: 17/255, blue: 17/255, opacity: 0.10)
    
    /// Shadow radius used for primary shadows
    static let PRIMARY_SHADOW_RADIUS = CGFloat(3)
    
    /// Shadow x and y for primary shadow
    static let PRIMARY_SHADOW_X_Y = CGFloat(2)
    
    /// Shadow radius for secondary shadows
    static let SECONDARY_SHADOW_RADIUS = CGFloat(1)
    
    /// Shadow x and y for secondary shadows
    static let SECONDARY_SHADOW_X_Y = CGFloat(1)
    
    /// Font name for Roboto Condensed Bold
    static let ROBOTO_CONDENSED_BOLD = "RobotoCondensed-Bold"
    
    /// Background color of list view
    static let LIST_VIEW_BACKGROUND_COLOR = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
}
