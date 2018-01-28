//
//  ViewController.swift
//  testBlog
//
//  Created by Mac on 17.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tablePost: UITableView!
    
    //MARK: Properties
    var model = PostsViewModel()
    var route: PostsRouting!
    
    var disposeBag = DisposeBag()

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        route = PostsRouting(with: self)
        
        model.listPosts.bind(to: tablePost.rx.items(cellIdentifier: "Cell", cellType: PostTableViewCell.self)) { row, post, cell in
            cell.currentPost = post
        }.disposed(by: disposeBag)
        
        tablePost.rx.modelSelected(Post.self).subscribe(onNext: {
            self.route.goToPost(id: $0.id)
        }).disposed(by: disposeBag)
        
    }

}

