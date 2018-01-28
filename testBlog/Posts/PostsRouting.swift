//
//  PostRouting.swift
//  testBlog
//
//  Created by Mac on 25.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PostsRouting {
    
    weak var viewController: PostsViewController!
    
    enum ViewControllers: String {
        case postVC = "postVC"
    }
    
    init(with postsVC: PostsViewController) {
        viewController = postsVC
    }
    
    func goToPost(id: Int) {
        
        let postVC = InternalHelper.StoryboardType.main.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.postVC.rawValue) as! PostViewController
        
        postVC.model = PostViewModel(with: id)

        viewController.navigationController?.pushViewController(postVC, animated: true)
    }
}
