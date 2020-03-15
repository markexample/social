//
//  ProfileView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage
import FirebaseAuth

/// Profile view containing a list of posts from the current Firebase user
struct ProfileView: View {
    
    /// Post model data for post data on list
    @ObservedObject var pm: PostModel
    
    /// Size of the main profile picture
    private let PROFILE_PIC_SIZE = CGFloat(120)
    
    /// Font size for the main profile name
    private let NAME_FONT_SIZE = CGFloat(25)
    
    /// Border line width for the main profile picture
    private let BORDER_LINE_WIDTH = CGFloat(5)
    
    /// Padding on top of the profile picture
    private let PADDING_PROFILE_PIC_TOP = CGFloat(20)
    
    /// Placeholder when user has no posts
    private let PLACEHOLDER_NO_POSTS = "You don't have any posts yet."
    
    /// Opacity for placeholder
    private let PLACEHOLDER_OPACITY = 0.35
    
    /// Initializer for profile view
    /// - Parameter pm: Post model for the post data on the list
    init(pm: PostModel) {
        
        // Set the post model for post data on list
        self.pm = pm
    }
    
    /// Body of profile view
    var body: some View {
        ZStack{
            Constants.PAGE_BACKGROUND_COLOR.edgesIgnoringSafeArea(.all)
            VStack{
                KFImage(
                    URL(string: Util.getProfilePic(quality: .high))!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: PROFILE_PIC_SIZE, height: PROFILE_PIC_SIZE)
                    .clipShape(Circle())
                    .shadow(color: Constants.SHADOW_COLOR, radius: Constants.SECONDARY_SHADOW_RADIUS, x: Constants.SECONDARY_SHADOW_X_Y, y: Constants.SECONDARY_SHADOW_X_Y)
                    .overlay(Circle().stroke(Color.white, lineWidth: BORDER_LINE_WIDTH))
                Text(Auth.auth().currentUser!.displayName!)
                    .font(.system(size: NAME_FONT_SIZE)).bold()
                ZStack{
                    ListView(type: .profile, pm: pm)
                    Text(PLACEHOLDER_NO_POSTS)
                        .opacity(pm.profilePosts.count == 0 ? PLACEHOLDER_OPACITY : 0)
                }
            }
            .padding([.top], PADDING_PROFILE_PIC_TOP)
        }
    }
    
}
