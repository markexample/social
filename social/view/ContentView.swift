//
//  ContentView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import struct Kingfisher.KFImage
import FirebaseAuth
import CodableFirebase
import UIKit

/// Content view representing the main screen/view of the app when logged into Firebase
public struct ContentView: View {
    
    /// Color used in header view
    private let HEADER_COLOR = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Image color for tabs when selected
    private let TAB_IMAGE_COLOR_ON = UIColor(red: 255/255, green: 145/255, blue: 148/255, alpha: 1)
    
    /// Image color for tabs when not selected
    private let TAB_IMAGE_COLOR_OFF = UIColor.lightGray
    
    /// Color of text on tabs when selected
    private let TAB_TITLE_COLOR_ON = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Color of text on tabs when not selected
    private let TAB_TITLE_COLOR_OFF = Color.gray
    
    /// Number of tabs
    private let NUM_OF_TABS = 3
    
    /// Array used for text on each tab in the order of the tabs
    private let TAB_TITLES = ["Home", "Post", "Profile"]
    
    /// Size of images on tabs
    private let TAB_IMAGE_SIZE = CGFloat(25)
    
    /// Font size of text on tabs
    private let TAB_TITLE_FONT_SIZE = CGFloat(16)
    
    /// State array for tracking the image color on tabs
    @State private var tabImageColors = [
           UIColor(red: 255/255, green: 145/255, blue: 148/255, alpha: 1),
           UIColor.lightGray,
           UIColor.lightGray
       ]
    
    /// State array for tracking the color of text on tabs
    @State private var tabTitleColors = [
        Color(red: 255/255, green: 145/255, blue: 148/255),
        Color.gray,
        Color.gray
    ]
    
    /// State for tracking currently selected tab
    @State private var currentTab = 0
    
    /// Extra padding on the top of tabs
    private let TABS_PADDING_TOP = CGFloat(10)
    
    /// Extra padding used on the bottom of tabs
    private let TABS_PADDING_BOTTOM = CGFloat(3)
    
    /// Height of the header view
    private let HEADER_HEIGHT = CGFloat(25)
    
    /// Height of the footer containing the tabs
    private let FOOTER_HEIGHT = CGFloat(30)
    
    /// Title of the header
    private let HEADER_TITLE = "Social App"
    
    /// Font size of the title on the header
    private let HEADER_TITLE_FONT_SIZE = CGFloat(25)
    
    /// Leading padding on the title of the header
    private let HEADER_TITLE_PADDING_LEADING = CGFloat(20)
    
    /// Trailing padding on the logout button of the header
    private let HEADER_LOGOUT_PADDING_TRAILING = CGFloat(20)
    
    /// Name of the local image for the logout button
    private let LOGOUT_IMAGE = "logout"
    
    /// Size of the image for the logout button
    private let LOGOUT_IMAGE_SIZE = CGFloat(25)
    
    /// Post model used for the home and screen view lists
    @ObservedObject var pm: PostModel = PostModel()
    
    /// Extra header padding when no safe area exists
    private let EXTRA_HEADER_PADDING = CGFloat(40)
    
    private let EXTRA_FOOTER_PADDING = CGFloat(30)
    
    /// Body of content view
    public var body: some View {
        ZStack{
            VStack(spacing: 0){
                Spacer()
                    .frame(height: getHeaderHeight())
                GeometryReader { geometry in
                    PageScrollView(currentTab: self.$currentTab, height: geometry.size.height, pm: self.pm)
                }
                ZStack{
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: getFooterHeight())
                        .shadow(color: Constants.SHADOW_COLOR, radius: Constants.PRIMARY_SHADOW_RADIUS, x: Constants.PRIMARY_SHADOW_X_Y, y: -Constants.PRIMARY_SHADOW_X_Y)
                    HStack{
                        ForEach(0 ..< NUM_OF_TABS){ index in
                            Spacer()
                            VStack{
                                TabImageView(index: index, tabImageColors: self.$tabImageColors)
                                    .frame(width: self.TAB_IMAGE_SIZE, height: self.TAB_IMAGE_SIZE)
                                Text(self.TAB_TITLES[index])
                                    .font(.system(size: self.TAB_TITLE_FONT_SIZE))
                                    .foregroundColor(self.tabTitleColors[index])
                            }
                            .padding(EdgeInsets(top: self.TABS_PADDING_TOP, leading: 0, bottom: self.getTabsBottomPadding(), trailing: 0))
                            .gesture(
                                TapGesture()
                                    .onEnded({ (_) in
                                        self.changeTab(tab: index)
                                    })
                            )
                            Spacer()
                        }
                    }
                }
            }
            VStack(spacing: 0){
                ZStack{
                    HEADER_COLOR
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: getHeaderHeight())
                        .shadow(color: Constants.SHADOW_COLOR, radius: Constants.PRIMARY_SHADOW_RADIUS, x: Constants.PRIMARY_SHADOW_X_Y, y: Constants.PRIMARY_SHADOW_X_Y)
                    HStack{
                        Text(self.HEADER_TITLE)
                            .font(.system(size: self.HEADER_TITLE_FONT_SIZE)).bold()
                            .foregroundColor(.white)
                            .frame(alignment: .leading)
                            .padding([.leading], self.HEADER_TITLE_PADDING_LEADING)
                        Spacer()
                        ImageView(name: self.LOGOUT_IMAGE, color: UIColor.white)
                            .frame(width: self.LOGOUT_IMAGE_SIZE, height: self.LOGOUT_IMAGE_SIZE, alignment: .trailing)
                            .padding([.trailing], self.HEADER_LOGOUT_PADDING_TRAILING)
                            .gesture(
                                TapGesture()
                                    .onEnded({ (_) in
                                        self.logout()
                                    })
                            )
                    }
                }
                Spacer()
            }
        }
    }
    
    /// Get the height of the header view
    func getHeaderHeight()->CGFloat{
        
        /// Get top value of safe area
        let top = Util.getSafeArea().top
        
        // If top area exists, return top and header height
        // Otherwise return extra padding and header height
        return top > 0 ? top + HEADER_HEIGHT : EXTRA_HEADER_PADDING + HEADER_HEIGHT
    }
    
    /// Get the height of the footer view
    func getFooterHeight()->CGFloat{
        
        /// Get top value of safe area
        let bottom = Util.getSafeArea().bottom
        
        // If bottom area exists, return top and header height
        // Otherwise return extra padding and header height
        return bottom > 0 ? bottom + FOOTER_HEIGHT : EXTRA_FOOTER_PADDING + FOOTER_HEIGHT
    }
    
    /// Get the bottom padding of the tabs
    func getTabsBottomPadding()->CGFloat{
        
        /// Get top value of safe area
        let bottom = Util.getSafeArea().bottom
        
        // If bottom area exists, return no padding
        // Otherwise return extra padding and header height
        return bottom > 0 ? 0 : TABS_PADDING_BOTTOM
    }
    
    /// Logout of Firebase
    func logout(){
        
        // Sign out of Firebase
        try? Auth.auth().signOut()
        
        // Animate login transition for logging out
        Util.animateLoginTransition(type: .logout)
    }
    
    /// Change the selected tab
    /// - Parameter tab: new tab position selected
    func changeTab(tab: Int){
        
        // Iterate through the list of colors for the tab titles
        for index in 0 ..< tabTitleColors.count {
            
            // Set the tab color based on the state of the tab selected on or off
            tabTitleColors[index] = tab == index ? TAB_TITLE_COLOR_ON : TAB_TITLE_COLOR_OFF
        }
        
        // Iterate through the list of colors for the images on the tabs
        for index in 0 ..< tabImageColors.count {
            
            // Set the color of the image on the tab based on the state of the tab selected on or off
            tabImageColors[index] = tab == index ? TAB_IMAGE_COLOR_ON : TAB_IMAGE_COLOR_OFF
        }
        
        // Set the current tab to the newly selected tab
        currentTab = tab
    }
    
}
