//
//  Models.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-23.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import Foundation

enum Gender {
   case male, female, other
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birthDate: Date
    let gender: Gender
    let counts: UserCounts
    let joinDate: Date
}

struct UserCounts {
    let followers: Int
    let followings: Int
    let posts: Int
}



public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

/// Representes a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL // either video url or full resolution photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggUsers: [String]
    let price: [Price]
    let owner: User
    
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

struct Price {
    let price: Int
}
