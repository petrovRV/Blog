//
//  CommentSection.swift
//  testBlog
//
//  Created by Mac on 28.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import RxDataSources

struct CommentSection {
    var items: [Item]
}

extension CommentSection : SectionModelType {
    
    typealias Item = Comment
    
    var identity: String {
        return ""
    }
    
    init(original: CommentSection, items: [Comment]) {
        self = original
        self.items = items
    }
}
