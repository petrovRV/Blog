//
//  Comment.swift
//  testBlog
//
//  Created by Mac on 28.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var author: String
    var id: Int
    var text: String
    var datePublic: Date?
}
