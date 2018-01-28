//
//  Post.swift
//  testBlog
//
//  Created by Mac on 18.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import RxSwift

class PostViewModel {
    
    //MARK: Properties
    private let request = RequestService()
    private let formatter = DateFormatter()
    
    var postId: Int
    var postObject = Observable<Post>.empty()
    var commentSections = Observable<[CommentSection]>.empty()
    var commentText = ""
    var statusSendMessage = Observable<Result>.empty()
    
    var disposeBag = DisposeBag()
    
    init(with postId: Int) {
        self.postId = postId
    }
    
    func getPost(closure: @escaping () -> ()) {
        
        postObject = request.getPost(with: postId)
        
        request.getComments(with: postId)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.commentSections = Observable.just([CommentSection(items: $0)])
                closure()
            })
            .disposed(by: disposeBag)
    }
    
    func sendComment() {
        let param = ["comment": commentText]
        statusSendMessage = request.sendComment(with: param)
    }
    
}
