//
//  Post.swift
//  testBlog
//
//  Created by Mac on 17.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

struct Post: Codable {
    var id: Int
    var datePublic: Date?
    var text: String
    var title: String
}
