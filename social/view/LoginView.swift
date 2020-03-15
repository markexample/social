//
//  LoginView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import FacebookLogin
import FacebookCore
import FirebaseAuth
import UIKit

/// Login view shown when a Firebase user is not logged in
struct LoginView: View {
    
    /// Subtitle for the login view
    private let SUBTITLE = "Create Your Own Social App With Us!"
    
    /// Font size for the subtitle
    private let SUBTITLE_FONT_SIZE = CGFloat(20)
    
    /// Background color of the login view
    private let BACKGROUND_COLOR = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Title of the log in button
    @State private var buttonTitle = "CONTINUE WITH FACEBOOK"
    
    /// Corner radius for the log in button
    private let BUTTON_CORNER_RADIUS = CGFloat(8)
    
    /// Font size for the log in button
    private let BUTTON_FONT_SIZE = CGFloat(20)
    
    /// Vertical spacing between the title image and subtitle
    private let TITLE_SUBTITLE_SPACING = CGFloat(20)
    
    /// Horizontal padding on the sides of the title image
    private let TITLE_PADDING_HORIZONTAL = CGFloat(10)
    
    /// Total horizontal margin subtracted when calculating log in button width
    private let BUTTON_MARGIN_HORIZONTAL = CGFloat(40)
    
    /// Height of the log in button
    private let BUTTON_HEIGHT = CGFloat(60)
    
    /// Vertical spacing on the bottom of the log in button
    private let BUTTON_BOTTOM_SPACING = CGFloat(20)
    
    /// Login manager used to log into Facebook
    private var loginManager = LoginManager()
    
    /// State boolean to track showing the view controller used on the Facebook login method
    @State private var showingViewController = false
    
    /// Name of the local image for the title image
    private let TITLE_IMAGE = "logo"
    
    /// Size of the title image
    private let TITLE_IMAGE_SIZE = CGFloat(200)
    
    /// Body of login view
    var body: some View {
        ZStack{
            BACKGROUND_COLOR.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                VStack(spacing: TITLE_SUBTITLE_SPACING){
                    Image(TITLE_IMAGE)
                        .resizable()
                        .frame(width: TITLE_IMAGE_SIZE, height: TITLE_IMAGE_SIZE)
                    Text(self.SUBTITLE)
                        .foregroundColor(.white)
                        .font(.custom(Constants.ROBOTO_CONDENSED_BOLD, size: SUBTITLE_FONT_SIZE))
                }
                Spacer()
                Button(action: {
                    self.showingViewController = true
                }) {
                    Text(buttonTitle)
                        .font(.custom(Constants.ROBOTO_CONDENSED_BOLD, size: BUTTON_FONT_SIZE))
                        .frame(width: UIScreen.main.bounds.width - BUTTON_MARGIN_HORIZONTAL, height: BUTTON_HEIGHT)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(BUTTON_CORNER_RADIUS)
                        .shadow(color: Constants.SHADOW_COLOR, radius: Constants.SECONDARY_SHADOW_RADIUS, x: Constants.SECONDARY_SHADOW_X_Y, y: Constants.SECONDARY_SHADOW_X_Y)
                }
                .sheet(isPresented: $showingViewController) {
                    LoginViewController(buttonTitle: self.$buttonTitle)
                }
                Spacer()
                .frame(height: BUTTON_BOTTOM_SPACING)
            }
        }
    }
    
}
