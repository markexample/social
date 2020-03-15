//
//  TabImageView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Image view represented to change tab image view
struct TabImageView: UIViewRepresentable{
    
    /// Index of tab
    private var index: Int
    
    /// Tint color of images on tabs
    @Binding var tabImageColors: [UIColor]
    
    /// Local names of images on tabs
    private let TAB_IMAGES = ["home", "post", "profile"]
    
    /// Initializer for tab image view
    /// - Parameters:
    ///   - index: index of tab
    ///   - tabImageColors: binding array of tint colors on tab images
    init(index: Int, tabImageColors: Binding<[UIColor]>) {
        
        // Set index of tab
        self.index = index
        
        // Set binding variable of array of tab image colors
        _tabImageColors = tabImageColors
    }
    
    
    /// Make the tab image view
    /// - Parameter context: Context of tab image view
    func makeUIView(context: UIViewRepresentableContext<TabImageView>) -> UIImageView {
        
        // Create the UIImageView
        let imageView = UIImageView()
        
        // Set the image from the tab image name array using the the index and set the rendering mode to alwaysTemplate for tint color
        imageView.image = UIImage(named: TAB_IMAGES[index])?.withRenderingMode(.alwaysTemplate)
        
        // Set the tint color from the tab image colors using the index
        imageView.tintColor = tabImageColors[index]
        
        // Return the image view
        return imageView
    }
    
    /// Update the image view
    /// - Parameters:
    ///   - uiView: Image view
    ///   - context: Context of image view
    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<TabImageView>) {
        
        // Change the tint color when the index/selected tab changes
        uiView.tintColor = tabImageColors[index]
    }
    
}
