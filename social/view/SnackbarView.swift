//
//  SnackbarView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Snackbar view based on Android Snackbar look
struct SnackbarView<Presenting>: View where Presenting: View {

    /// Boolean when snackbar should be showing
    @Binding var isShowing: Bool
    
    /// The view that will be "presenting" this snackbar
    let presenting: () -> Presenting
    
    /// Text to show on the snackbar
    let text: Text
    
    /// Height of snackbar
    private let HEIGHT = CGFloat(75)
    
    /// Background color of snackbar
    private let BACKGROUND_COLOR = Color(red: 17/255, green: 17/255, blue: 17/255).opacity(0.8)
    
    /// Body of snackbar view
    var body: some View {
        
        // Do action when the snackbar is showing
        do { if self.isShowing {
            
            // After 1 second on the main thread
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                // With animation to show the transition
                withAnimation{
                    
                    // Set the snackbar showing to false
                    self.isShowing = false
                }
            }
        }}
        
        // Return view for the body
        return ZStack(alignment: .bottom) {
            self.presenting()
            VStack {
                text
            }
            .frame(width: UIScreen.main.bounds.width, height: HEIGHT)
            .background(BACKGROUND_COLOR)
            .foregroundColor(.white)
            .transition(.slide)
            .opacity(self.isShowing ? 1 : 0)
        }
    }
}

// Extension of view to show snackbar
extension View {
    
    /// Show snackbar
    /// - Parameters:
    ///   - isShowing: Binding boolean for showing the snackbar
    ///   - text: Text to show on snackbar
    func snackbar(isShowing: Binding<Bool>, text: Text) -> some View {
        
        // Create a snackbar view, passing in parameters
        SnackbarView(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}
