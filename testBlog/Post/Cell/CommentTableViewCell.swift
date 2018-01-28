//
//  CommentTableViewCell.swift
//  testBlog
//
//  Created by Mac on 28.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let formatter = DateFormatter()
    
    var currentComment: Comment! {
        didSet {
            formatter.dateFormat = "yyyy.MM.dd"
            let strDate = formatter.string(from: currentComment.datePublic!)
            dateLabel.text = strDate
            authorLabel.text = currentComment?.author
            descriptionLabel.text = currentComment?.text
        }
    }
}
