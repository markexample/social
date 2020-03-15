//
//  PostModel.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import CodableFirebase
import FirebaseFirestore

/// Post model used for post data on home and profile view lists
public class PostModel: ObservableObject {
    
    /// Array of post data for home view list
    @Published var homePosts = [Post]()
    
    /// Array of post data for profile view list
    @Published var profilePosts = [Post]()
    
    /// Add post to post data array for home view
    /// - Parameter post: Post data to add
    func addHomePost(post: Post){
        
        // Add post to home posts array
        homePosts.append(post)
    }
    
    /// Add post to post data array for profile view
    /// - Parameter post: Post data to add
    func addProfilePost(post: Post){
        
        // Add post to profile posts array
        profilePosts.append(post)
    }
    
    /// Insert post to both post data arrays when user posts
    /// - Parameter post: Post data to insert
    func insertPostBothLists(post: Post){
        
        // Insert post to home posts array
        homePosts.insert(post, at: 0)
        
        // Insert post to profile posts array
        profilePosts.insert(post, at: 0)
    }
    
}

/// Identifiable for post used to iterate on list
struct Post: Identifiable{
    
    /// Post id
    var id: String
    
    /// Post date
    var date: String
    
    /// Post message
    var message: String
    
    /// Name of user on post
    var name: String
    
    /// Profile picture of user on post
    var profilePic: String
    
    /// The uid of user on post
    var uid: String
    
    /// Initializer for post model
    /// - Parameters:
    ///   - id: Post id
    ///   - date: Post date
    ///   - message: Post message
    ///   - name: Name of user on post
    ///   - profilePic: Profile picture of user on post
    ///   - uid: The uid of the user on post
    init(id: String, date: String, message: String, name: String, profilePic: String, uid: String) {
        
        // Set the post id
        self.id = id
        
        // Set the date
        self.date = date
        
        // Set the post message
        self.message = message
        
        // Set the name of user on post
        self.name = name
        
        // Set the profile picture of user on post
        self.profilePic = profilePic
        
        // Set the uid of user on post
        self.uid = uid
    }
}

/// Codable for post used to decode data from Firestore
struct PostCodable: Codable{
    
    /// Document id of Firestore document
    let documentId: String
    
    /// Fields of Firestore document
    /// (date, message, name, profile picture and uid)
    var date = "",
    message = "",
    name = "",
    profilePic = "",
    uid = ""
}


/// Encodable for post used to encode data to Firestore
struct PostData: Encodable{
    
    /// Date of post as current server timestamp
    var date: FieldValue
    
    /// Post message
    var message: String
    
    /// Name of user on post
    var name: String
    
    /// Profile picture of user on post
    var profilePic: String
    
    /// The uid of the user on post
    var uid: String
}

/// Extention of FieldValue to allow Encodable to use FieldValue for timestamps
extension FieldValue: FieldValueType {}
