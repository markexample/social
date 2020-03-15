//
//  ImageView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Image view represented to change tint color
struct ImageView: UIViewRepresentable{
    
    /// Name of local image
    private let name: String
    
    /// Color of image tint
    private var color: UIColor
    
    /// Initializer for image view
    /// - Parameters:
    ///   - name: Name of local image
    ///   - color: Color of image tint
    init(name: String, color: UIColor) {
        
        // Set name of local image
        self.name = name
        
        // Set color for tint of image
        self.color = color
    }
    
    /// Make the image view
    /// - Parameter context: Context of image view
    func makeUIView(context: UIViewRepresentableContext<ImageView>) -> UIImageView {
        
        // Create the UIImageView
        let imageView = UIImageView()
        
        // Set the image from the set name and set the rendering mode to alwaysTemplate for tint color
        imageView.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        
        // Set the tint color from the set color
        imageView.tintColor = color
        
        // Return the image view
        return imageView
    }
    
    /// Update the imagew view
    /// - Parameters:
    ///   - uiView: Image view
    ///   - context: Context of image view
    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<ImageView>) {
        
    }
    
}
