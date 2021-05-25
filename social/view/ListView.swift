//
//  ListView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import struct Kingfisher.KFImage

/// List view for lists on home and profile views
struct ListView: View {
    
    /// Outter padding on main view of rows
    private let OUTER_PADDING = CGFloat(10)
    
    /// Font size of name
    private let NAME_FONT_SIZE = CGFloat(15)
    
    /// Font size of date
    private let DATE_FONT_SIZE = CGFloat(15)
    
    /// Font size of message
    private let MESSAGE_FONT_SIZE = CGFloat(20)
    
    /// Padding on inner elements of main view
    private let INNER_LEADING_PADDING = CGFloat(10)
    
    /// Corner radius of main view of rows
    private let ROW_CORNER_RADIUS = CGFloat(8)
    
    /// Firestore field for date
    private let DATE_FIELD = "date"
    
    /// Firestore document id key
    private let DOCUMENT_ID_KEY = "documentId"
    
    /// Date format used in date shown on posts
    private let DATE_FORMAT = "MMM d, yyyy"
    
    /// Date formatter used to format dates on posts
    private let formatter = DateFormatter()
    
    /// Firestore field for uid
    private let UID_FIELD = "uid"
    
    /// Enumeration type for the type of list on home or profile view
    enum ListType {
        case home
        case profile
    }
    
    /// Enumeration type variable to track type of list
    private let type: ListType
    
    /// Post model for post data on list
    @ObservedObject var pm: PostModel
    
    /// Size for the profile pic
    private let PROFILE_PIC_SIZE = CGFloat(30)
    
    /// Font size for the profile pic letter
    private let PROFILE_PIC_FONT_SIZE = CGFloat(20)
    
    /// Border line width for the profile picture
    private let BORDER_LINE_WIDTH = CGFloat(4)
    
    /// Color used in profile pic view
    private let PROFILE_PIC_COLOR = Color(red: 255/255, green: 145/255, blue: 148/255)
    
    /// Outside padding on main view of rows
    private let OUTSIDE_PADDING = CGFloat(20)
    
    /// Vertical padding between rows
    private let ROW_TOP_BOTTOM_PADDING = CGFloat(4)
    
    /// Horizontal padding between screen walls and rows
    private let ROW_LEADING_TRAILING_PADDING = CGFloat(12)
    
    /// Extra top and bottom padding for first and last row of the list
    private let LIST_TOP_BOTTOM_PADDING = CGFloat(4)
    
    /// Vertical spacing between profile picture and message
    private let PHOTO_MESSAGE_SPACING = CGFloat(15)
    
    /// Background color of list view
    private let LIST_VIEW_BACKGROUND_COLOR = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    
    /// Initializer for list view
    /// - Parameters:
    ///   - type: Type of list used
    ///   - pm: Post model for list
    init(type: ListType, pm: PostModel) {
        
        // Set type of list
        self.type = type
        
        // Set post model for list
        self.pm = pm
    }
    
    /// Get the post data array from post model based on the type of list
    func getPosts()->[Post]{
        
        // If the list type is for the home screen
        if(type == .home){
            
            // Return the home posts array
            return pm.homePosts
        }
        
        // Otherwise return the profile posts array
        return pm.profilePosts
    }
    
    // Custom List for iOS 14 list separator issue
    struct CustomList<Content: View>: View {
        
        /// Background color of list view
        private let LIST_VIEW_BACKGROUND_COLOR = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        /// Outside padding on main view of rows
        private let OUTSIDE_PADDING = CGFloat(10)
        
        let content: () -> Content
        
        var body: some View {
            if #available(iOS 14.0, *) {
                ScrollView {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .foregroundColor(.clear)
                    LazyVStack{
                        self.content()
                    }
                        .background(Color(LIST_VIEW_BACKGROUND_COLOR))
                        .padding([.leading, .trailing], self.OUTSIDE_PADDING)
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .foregroundColor(.clear)
                }
                .background(Color(LIST_VIEW_BACKGROUND_COLOR))
            } else {
                List {
                    self.content()
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    // Body for list view
    var body: some View{
        CustomList{
            ForEach(0..<getPosts().count, id: \.self){ index in
                VStack(spacing: self.PHOTO_MESSAGE_SPACING){
                    HStack{
                        Circle()
                            .stroke(PROFILE_PIC_COLOR, lineWidth: BORDER_LINE_WIDTH)
                            .frame(width: PROFILE_PIC_SIZE, height: PROFILE_PIC_SIZE, alignment: .center)
                            .padding([.leading, .top], self.OUTER_PADDING)
                            .overlay(
                                Text(String(self.getPosts()[index].name.prefix(1)).uppercased())
                                    .font(.system(size: PROFILE_PIC_FONT_SIZE).bold())
                                    .frame(width: PROFILE_PIC_SIZE, height: PROFILE_PIC_SIZE, alignment: .center)
                                    .foregroundColor(.black)
                                    .padding([.leading, .top], self.OUTER_PADDING)
                            )
                        VStack{
                            Text(self.getPosts()[index].name)
                                .foregroundColor(.black)
                                .font(.system(size: self.NAME_FONT_SIZE))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .top], self.INNER_LEADING_PADDING)
                            Text(self.getPosts()[index].date)
                                .foregroundColor(.gray)
                                .font(.system(size: self.DATE_FONT_SIZE))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], self.INNER_LEADING_PADDING)
                        }
                    }
                    Text(self.getPosts()[index].message)
                        .foregroundColor(.black)
                        .font(.system(size: self.MESSAGE_FONT_SIZE)).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], self.OUTER_PADDING)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets(top: index == 0 ? self.ROW_TOP_BOTTOM_PADDING + self.LIST_TOP_BOTTOM_PADDING : self.ROW_TOP_BOTTOM_PADDING, leading: self.ROW_LEADING_TRAILING_PADDING, bottom: index == self.getPosts().count - 1 ? self.ROW_TOP_BOTTOM_PADDING + self.LIST_TOP_BOTTOM_PADDING : self.ROW_TOP_BOTTOM_PADDING, trailing: self.ROW_LEADING_TRAILING_PADDING))
                .background(Color.white)
                .cornerRadius(self.ROW_CORNER_RADIUS)
                .shadow(color: Constants.SHADOW_COLOR, radius: Constants.SECONDARY_SHADOW_RADIUS, x: Constants.SECONDARY_SHADOW_X_Y, y: Constants.SECONDARY_SHADOW_X_Y)
            }
        }
        .onAppear{
            
            // When the list view has appeared, fetch the posts for the list
            self.fetchPosts()
        }
    }
    
    /// Get the Firestore query based on the type of list
    func getQuery()->Query{
        
        // Create a base Firestore query used on the home and profile screen types
        // sorted by descending dates (most recent date first)
        let query = Firestore.firestore().collection(Constants.COLLECTION_POSTS)
        .order(by: self.DATE_FIELD, descending: true)
        
        // If the list type is for the home screen
        if(type == .home){
            
            // Return query for home list
            return query
        }
        
        // Otherwise return query for profile list
        // where the uid is the current Firebase user
        return query.whereField(UID_FIELD, isEqualTo: Auth.auth().currentUser!.uid)
    }
    
    /// Fetch the posts for the list
    func fetchPosts(){
        
        // Create a Firestore query based on the screen type
        let query = getQuery()
        
        // Fetch the documents from the query
        query.getDocuments { (snapshot, error) in
            
            // If there is an error
            guard error == nil, let docs = snapshot else{
                
                // Print the error
                print(error!.localizedDescription)
                
                // Return from fetching posts
                return
            }
            
            // Iterate through the documents returned
            for doc in docs.documents{
                
                // For each document, get the data dictionary from it
                var dict = doc.data()
                
                // Add the document field to the dictionary for decoding
                dict[self.DOCUMENT_ID_KEY] = doc.documentID
                
                // Iterate through the dictionary
                for(key, value) in dict{
                    
                    // Check for timestamp types
                    if let value = value as? Timestamp{
                        
                        // Set the date format for the date formatter
                        self.formatter.dateFormat = self.DATE_FORMAT
                        
                        // Set the value for the timestamp type key to
                        // a string value from the date formatter
                        // using the date value from the Firestore timestamp type
                        dict[key] = self.formatter.string(from: value.dateValue())
                    }
                }
                
                // Create the JSON data from the dictionary
                guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else{ return }
                
                // Decode the JSON data into a Codable type representing a post
                guard let postCodable = try? JSONDecoder().decode(PostCodable.self, from: data) else{ return }
                
                // Create identifable type representing post for post arrays
                let post = self.getPost(postCodable: postCodable)
                
                // If the post is for the home screen type
                if(self.type == .home){
                    
                    // Add the post to the home screen post array
                    self.pm.addHomePost(post: post)
                }else{
                    
                    // Otherwise add the post to the profile screen post array
                    self.pm.addProfilePost(post: post)
                }
            }
        }
    }
    
    /// Get the post for post arrays using codable types passed in when reading from Firestore queries
    /// - Parameter postCodable: Codable type when reading queries
    private func getPost(postCodable: PostCodable)-> Post{
        
        // Return a new identifiable type of post for post arrays using the codable parameter
        // passed in
        return Post(id: postCodable.documentId, date: postCodable.date, message: postCodable.message, name: postCodable.name, profilePic: postCodable.profilePic, uid: postCodable.uid)
    }
    
    /// Get the post for post arrays using using the encodable type when posting
    /// - Parameter postData: Encodable type of post passed in when posting
    static func getPost(postData: PostData)-> Post{
        
        // Return a new identifiable type of post for post arrays using the encodable paramter
        // passed in
        return Post(id: "", date: "Now", message: postData.message, name: postData.name, profilePic: postData.profilePic, uid: postData.uid)
    }
    
}
