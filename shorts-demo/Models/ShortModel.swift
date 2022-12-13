//
//  ShortModel.swift
//  shorts-demo
//
//  Created by Andre on 2022/12/8.
//

import Foundation

struct ShortDataModel {
    let user: UserDataModel
    let title: String
    var likes: Int
    var isLiked: Bool
    let video: String
}

struct UserDataModel {
    let username: String
    let avatar: String
}
