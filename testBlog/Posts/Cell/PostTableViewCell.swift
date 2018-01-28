//
//  PostTableViewCell.swift
//  testBlog
//
//  Created by Mac on 17.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    private let formatter = DateFormatter()

    var currentPost: Post! {
        didSet {
            formatter.dateFormat = "yyyy.MM.dd"
            let strDate = formatter.string(from: currentPost.datePublic!)
            dateLabel.text = strDate
            titleLabel.text = currentPost?.title
            descriptionLabel.text = currentPost?.text
        }
    }

}
