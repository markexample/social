//
//  PageScrollView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Scroll view of pages used in main/content view
struct PageScrollView: UIViewRepresentable{
    
    /// Enumeraton for types of screens represented by their tabs
    private enum Screen {
        case home
        case post
        case profile
    }
    
    /// Array of screens representing the order of the screens by enumeration type
    private let screens = [Screen.home, .post, .profile]
    
    /// Height of header view
    private let HEADER_HEIGHT = CGFloat(25)
    
    /// Binding integer for the currently selected tab
    @Binding var currentTab: Int
    
    /// Height of GeometryReader passed in for scroll view height
    private let height: CGFloat
    
    /// Post model passed in for post data arrays
    @ObservedObject var pm: PostModel
    
    /// Initializer for page scroll view
    /// - Parameters:
    ///   - currentTab: Currently selected tab
    ///   - height: Height of scroll view from GeometryReader
    ///   - pm: Post model data for post arrays in home and profile views
    init(currentTab: Binding<Int>, height: CGFloat, pm: PostModel) {
        
        // Set binding integer for currently selected tab
        _currentTab = currentTab
        
        // Set height for scroll view from GeometryReader
        self.height = height
        
        // Set observed object post model
        self.pm = pm
    }
    
    /// Make the page scroll view
    /// - Parameter context: Context of page scroll view
    func makeUIView(context: UIViewRepresentableContext<PageScrollView>) -> UIScrollView {
        
        // Create the UIScrollView
        let scrollView = UIScrollView()
        
        // Set the scrolling disabled to allow tabs only
        scrollView.isScrollEnabled = false
        
        // Disable vertical scrolling indicators
        scrollView.showsVerticalScrollIndicator = false
        
        // Disable horizontal scrolling indicators
        scrollView.showsHorizontalScrollIndicator = false
        
        // Disable bouncing on scroll view
        scrollView.bounces = false
        
        // Create bounds variable for sizing
        var bounds = UIScreen.main.bounds
        
        // Modify bounds height to match passed in GeometryReader height
        bounds.size.height = height
        
        // Get the count of screens
        let count = screens.count
        
        // Set the scroll view content size from full screen width and number of screens
        // and the height from the passed in height
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(count), height: bounds.height)
        
        // Loop through the number of screens
        for index in 0 ..< count {
            
            // Create the content view for the screen, setting the x based on the index
            let contentView = UIView(frame: CGRect(x: bounds.width * CGFloat(index), y: 0, width: bounds.width, height: bounds.height))
            
            // Get the UIView screen passing in the screen index, content view bounds and post model
            guard let screen = self.getScreen(index: index, bounds: contentView.bounds, pm: pm) else{ continue }
            
            // Add the UIView screen to the content view
            contentView.addSubview(screen)
            
            // Add the content view to the scroll view
            scrollView.addSubview(contentView)
        }
        
        //return the scroll view
        return scrollView
    }
    
    /// Get the screen for each page
    /// - Parameters:
    ///   - index: Scren index
    ///   - bounds: Bounds of screen
    ///   - pm: Post model for screen
    func getScreen(index: Int, bounds: CGRect, pm: PostModel)->UIView?{
        
        // Determine screen
        switch screens[index] {
            
        // Home screen
        case .home:
            
            // Create the home view passing in the post model
            let homeView = UIHostingController(rootView: HomeView(pm : pm)).view
            
            // Set the home view frame to the passed in bounds
            homeView?.frame = bounds
            
            // Set translatesAutoresizingMaskIntoConstraints false to set sizing
            homeView?.translatesAutoresizingMaskIntoConstraints = false
            
            // Return home view
            return homeView
            
        // Post screen
        case .post:
            
            // Create the post view passing in the post model
            let postView = UIHostingController(rootView: PostView(pm: pm)).view
            
            // Set the post view frame to the passed in bounds
            postView?.frame = bounds
            
            // Set translatesAutoresizingMaskIntoConstraints false to set sizing
            postView?.translatesAutoresizingMaskIntoConstraints = false
            
            // Return post view
            return postView
            
        // Profile screen
        case .profile:
            
            // Create the post view passing in the post model
            let profileView = UIHostingController(rootView: ProfileView(pm: pm)).view
            
            // Set the profile view frame to the passed in bounds
            profileView?.frame = bounds
            
            // Set translatesAutoresizingMaskIntoConstraints false to set sizing
            profileView?.translatesAutoresizingMaskIntoConstraints = false
            
            // Return profile view
            return profileView
        }
    }
    
    /// Update page scroll view
    /// - Parameters:
    ///   - uiView: Page scroll view
    ///   - context: Context of page scroll view
    func updateUIView(_ uiView: UIScrollView, context: UIViewRepresentableContext<PageScrollView>) {
        
        // Get the offset to use from the current tab and full screen width
        let offset = CGPoint(x: CGFloat(currentTab) * UIScreen.main.bounds.width, y: 0)
        
        // Set the new content offset and animate it
        uiView.setContentOffset(offset, animated: true)
    }
    
}
