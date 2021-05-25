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
    private let PROFILE_PIC_SIZE = CGFloat(80)
    
    /// Color used in profile pic view
    private let PROFILE_PIC_COLOR = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Font size for the profile pic letter
    private let PROFILE_PIC_FONT_SIZE = CGFloat(40)
    
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
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack{
                Circle()
                    .fill(PROFILE_PIC_COLOR)
                    .frame(width: PROFILE_PIC_SIZE, height: PROFILE_PIC_SIZE, alignment: .center)
                    .overlay(
                        Text(Util.getProfileFirstLetter())
                            .font(.system(size: PROFILE_PIC_FONT_SIZE).bold())
                            .frame(width: PROFILE_PIC_SIZE, height: PROFILE_PIC_SIZE, alignment: .center)
                            .foregroundColor(.white)
                    )
                Text(Auth.auth().currentUser!.displayName!)
                    .font(.system(size: NAME_FONT_SIZE)).bold()
                    .foregroundColor(.black)
                ZStack{
                    Constants.PAGE_BACKGROUND_COLOR.edgesIgnoringSafeArea(.all)
                    ListView(type: .profile, pm: pm)
                    Text(PLACEHOLDER_NO_POSTS)
                        .foregroundColor(.black)
                        .opacity(pm.profilePosts.count == 0 ? PLACEHOLDER_OPACITY : 0)
                }
            }
            .padding([.top], PADDING_PROFILE_PIC_TOP)
        }
    }
    
}
