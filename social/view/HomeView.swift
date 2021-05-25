//
//  HomeView.swift
//  social
//
//  Created by Mark Dalton on 3/14/20.
//  Copyright © 2020 Dalton Technologies, Inc. All rights reserved.
//

import SwiftUI

/// Home view containing a list of posts from all users
struct HomeView: View {
    
    /// Observed object post model containing array of post data
    @ObservedObject private var pm: PostModel
    
    /// Initializer for home view passing in the post model from content view
    /// - Parameter pm: The post model containing array of post data
    init(pm: PostModel) {
        
        // Set structure variable to post model parameter
        self.pm = pm
        
        // Set background color of UITableView in list view
        UITableView.appearance().backgroundColor = Constants.LIST_VIEW_BACKGROUND_COLOR
        
        // Set background color of UITableViewCell in list view
        UITableViewCell.appearance().backgroundColor = Constants.LIST_VIEW_BACKGROUND_COLOR
        
        // Set seperator style of UITableView in list view
        UITableView.appearance().separatorStyle = .none
    }
    
    /// Body of home view
    var body: some View {
        ZStack{
            ListView(type: .home, pm: pm)
        }
    }
    
}
