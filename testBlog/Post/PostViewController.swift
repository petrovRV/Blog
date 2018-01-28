//
//  PostViewController.swift
//  testBlog
//
//  Created by Mac on 18.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
//import RxKeyboard

class PostViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tablePost: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var commentTextViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    var model: PostViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTable()
        prepareKeyboard()
        prepareTextViewAndSendButton()
        
    }
    
    //MARK: Methods
    func prepareTable() {
        self.tablePost.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        model.getPost {
            
            let dataSource = RxTableViewSectionedReloadDataSource<CommentSection>(
                configureCell: { ds, tv, ip, comment in
                    let cell = tv.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
                    
                    cell.currentComment = comment
                    
                    return cell
            },
                titleForHeaderInSection: { dataSource, index in
                    return "post"
            }
            )
            
            self.model.commentSections
                .bind(to: self.tablePost.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
            
        }
    }
    
    func prepareTextViewAndSendButton() {
        
        sendButton.rx.tap.asDriver()
            .drive(onNext: {
                
                self.model.sendComment()
                
                self.model.statusSendMessage
                    .subscribe(onNext: { _ in
                            self.commentTextView.text = nil
                            self.tablePost.reloadData()
                    }).disposed(by: self.disposeBag)
                
            })
            .disposed(by: disposeBag)
        
        commentTextView.rx
            .didChange
            .subscribe(onNext: {
                self.model.commentText = self.commentTextView.text
            }).disposed(by: disposeBag)
    }
    
}

//MARK: UITableViewDelegate
extension PostViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tablePost.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        
        model.postObject
            .subscribe(onNext: { header.currentPost = $0 })
            .disposed(by: disposeBag)
        
        return header
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Notification keyboard
extension PostViewController {
    
    func prepareKeyboard() {
        
        //        RxKeyboard.instance.visibleHeight
        //            .drive(onNext: { keyboardVisibleHeight  in
        //                self.view.setNeedsLayout()
        //                UIView.animate(withDuration: 0) {
        //                    self.commentTextViewBottomConstraint.constant = -1 * keyboardVisibleHeight
        //                    self.view.layoutIfNeeded()
        //            }
        //            })
        //            .disposed(by: disposeBag)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            animationKeyboard(with: keyboardRectangle.height)
        }
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        animationKeyboard(with: 0)
    }
    
    private func animationKeyboard(with constant: CGFloat) {
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
            self.commentTextViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
}
