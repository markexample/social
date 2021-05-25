//
//  PostView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import CodableFirebase
import FirebaseFirestore
import FirebaseAuth

/// Post view that user can add a new post
struct PostView: View {
    
    /// Color of post button
    private let POST_COLOR = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Title of main view
    private let TITLE = "What's on your mind?"
    
    /// Placeholder for text field
    private let PLACEHOLDER = "Type message here."
    
    /// Title of post button
    private let POST_TITLE = "POST"
    
    /// State variable for message of text field
    @State var message: String = ""
    
    /// Outter padding of main view
    private let OUTER_PADDING = CGFloat(16)
    
    /// Inner padding of main view
    private let INNER_PADDING = CGFloat(20)
    
    /// Font size of title in main view
    private let TITLE_FONT_SIZE = CGFloat(27)
    
    /// Font size of post button
    private let POST_FONT_SIZE = CGFloat(20)
    
    /// Vertical padding of post button
    private let POST_PADDING_VERTICAL = CGFloat(15)
    
    /// Horizontal padding of post button
    private let POST_PADDING_HORIZONTAL = CGFloat(25)
    
    /// Corner radius of main view
    private let VIEW_CORNER_RADIUS = CGFloat(8)
    
    /// Vertical spacing between title and text field of main view
    private let TITLE_TEXT_FIELD_SPACING = CGFloat(50)
    
    /// State boolean for showing snackbars
    @State var showSnackbar: Bool = false
    
    /// State variable for snackbar message to use
    @State var snackbarMessage: String = ""
    
    /// Snackbar message to display when posting an empty text field message
    private let EMPTY_MESSAGE = "Please type in a message."
    
    /// Snackbar message to display when your message has posted
    private let MESSAGE_POSTED = "Your message has posted!"
    
    /// Observed object for post model containing post data arrays
    @ObservedObject var pm: PostModel
    
    /// State boolean for refreshing text field state after posting
    @State private var refresh = false
    
    /// Vertical spacing between the main view and the post button
    private let VIEW_POST_SPACING = CGFloat(20)
    
    /// Initializer for post view
    /// - Parameter pm: Post model containing post data used in home and profile views
    init(pm: PostModel) {
        
        // Set the post model observed object variable from parameter
        self.pm = pm
    }
    
    // Body of post view
    var body: some View {
        ZStack{
            Constants.PAGE_BACKGROUND_COLOR.edgesIgnoringSafeArea(.all)
            VStack(spacing: VIEW_POST_SPACING){
                Spacer()
                Spacer()
                VStack(spacing: 0){
                    Text(TITLE)
                        .foregroundColor(.black)
                        .font(.system(size: TITLE_FONT_SIZE)).bold()
                        .padding([.leading, .top], INNER_PADDING)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: TITLE_TEXT_FIELD_SPACING)
                    ZStack(alignment: .leading) {
                        if message.isEmpty {
                            Text(PLACEHOLDER)
                                .foregroundColor(.gray)
                                .padding([.leading, .trailing], INNER_PADDING)
                        }
                        TextField("", text: $message)
                            .padding([.leading, .trailing], INNER_PADDING)
                            .foregroundColor(.black)
                    }
                    Divider()
                        .padding([.leading, .bottom, .trailing], INNER_PADDING)
                }
                .background(Color.white)
                .cornerRadius(VIEW_CORNER_RADIUS)
                .padding([.leading, .trailing], OUTER_PADDING)
                ZStack{
                    Text(POST_TITLE)
                        .font(.custom(Constants.ROBOTO_CONDENSED_BOLD, size: POST_FONT_SIZE))
                        .padding(EdgeInsets(top: POST_PADDING_VERTICAL, leading: POST_PADDING_HORIZONTAL, bottom: POST_PADDING_VERTICAL, trailing: POST_PADDING_HORIZONTAL))
                        .foregroundColor(.white)
                }
                .background(POST_COLOR)
                .cornerRadius(VIEW_CORNER_RADIUS)
                .shadow(color: Constants.SHADOW_COLOR, radius: Constants.PRIMARY_SHADOW_RADIUS, x: Constants.PRIMARY_SHADOW_X_Y, y: Constants.PRIMARY_SHADOW_X_Y)
                .gesture(
                    TapGesture()
                        .onEnded({ (_) in
                            self.post()
                        })
                )
                Spacer()
                Spacer()
            }
        }
        .snackbar(isShowing: $showSnackbar, text: Text(snackbarMessage))
    }
    
    /// Post a new post to both home and profile lists
    func post(){
        
        // Close the keyboard after tapping the post button
        UIApplication.shared.endEditing()
        
        // If the text field message is empty
        if(message == ""){
            
            // Set a snackbar message for empty message
            snackbarMessage = EMPTY_MESSAGE
            
            // Toggle the snackbar boolean to show the snackbar
            showSnackbar = true
            
            // Return from the post function
            return
        }
        
        // Get uid from Firebase user
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        // Get name from Firebase user
        guard let name = Auth.auth().currentUser?.displayName else{ return }
        
        // Create post data for new post
        let postData = PostData(date: FieldValue.serverTimestamp(), message: message, name: name, profilePic: Util.getProfilePic(quality: .low), uid: uid)
        
        // Encode a post dictionary for adding a Firestore document
        guard let postDict = try? FirestoreEncoder().encode(postData) else{ return }
         Firestore.firestore().collection(Constants.COLLECTION_POSTS).addDocument(data: postDict)
        
        // Set a snackbar message for message posted
        snackbarMessage = MESSAGE_POSTED
        
        // Toggle the snackbar boolean to show the snackbar
        showSnackbar = true
        
        // Create post for post arrays from post data
        let post = ListView.getPost(postData: postData)
        
        // Insert post to home and profile lists
        pm.insertPostBothLists(post: post)
        
        // Clear the text field message
        message = ""
        
        // Toggle the state boolean to show placeholder again
        refresh.toggle()
    }
    
}

/// Extention for adding functionality to UIApplication
extension UIApplication {
    
    /// Resign first responder to close keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
