//
//  RequestHendler.swift
//  testBlog
//
//  Created by Mac on 17.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class RequestService {
    
    let domain = "http://fed-blog.herokuapp.com/api/v1/"
    
    let network = Network()
    
    enum UrlLink {

        case posts, comments, marks
        
        func getUrlLink(urlParameter: String = "", urlParameter2: String = "") -> String {
            switch self {
            case .posts:
                return "posts/\(urlParameter)"
            case .comments:
                return "comments/\(urlParameter)\(urlParameter2)"
            case .marks:
                return "marks/"
            }
        }
    }
    
    func getPosts() -> Observable<[Post]> {
        
        if network.isInternetAvailable() {
            let url = domain + UrlLink.posts.getUrlLink()
            network.dateFormatter.dateFormat = "yyyy-MM-dd"
            return network.getObject(url: url, type: [Post].self)
        } else {
            return Observable.empty()
        }
        
    }
    
    func getPost(with id: Int) -> Observable<Post> {
        
        if network.isInternetAvailable() {
            let url = domain + UrlLink.posts.getUrlLink(urlParameter: String(id))
            network.dateFormatter.dateFormat = "yyyy-MM-dd"
            return network.getObject(url: url, type: Post.self)
        } else {
            return Observable.empty()
        }
        
    }
    
    func getComments(with id: Int) -> Observable<[Comment]> {
        if network.isInternetAvailable() {
            let url = domain + UrlLink.comments.getUrlLink(urlParameter: "posts/", urlParameter2: String(id))
            network.dateFormatter.dateFormat = "yyyy-MM-dd"
            return network.getObject(url: url, type: [Comment].self)
        } else {
            return Observable.empty()
        }
    }
    
    func sendComment(with param: [String: Any]) -> Observable<Result> {
        if network.isInternetAvailable() {
            let url = domain + UrlLink.comments.getUrlLink()
            return network.getObject(method: .post, url: url, parameters: param, encoding: JSONEncoding.default, heder: nil, type: Result.self)
          
        } else {
            return Observable.empty()
        }
    }
    
}
