//
//  PostDetailViewController.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import UIKit
import CoreData

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userWebLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var commentTableView: UITableView!
    
    
    var fetchedResultsController: NSFetchedResultsController<Comment>!
    var post: Post!
    var storeManager = StoreManager()
    var userService: UserService!
    var commentService: CommentService!
    var postService: PostService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userService = UserService(storeManager: storeManager)
        commentService = CommentService(storeManager: storeManager)
        postService = PostService(storeManager: storeManager)

        self.updateStarIconUi()
        self.setupFetchController()
        self.getCommentsFromStore()
        self.getUser()
        self.descriptionLabel.text = post.body
        self.descriptionLabel.sizeToFit()
    }
    
    //MARK: - CoreData
    func getUser() {
        if self.post.user == nil {
         self.getUserHttp()
        }
        self.updateUserInfoUi()
    }
    func cacheUser(user: UserDto) {
        self.post.user = self.userService.save(id: user.id, name: user.name, email: user.email, phone: user.phone, web: user.website)
        storeManager.saveContext()
    }
    func cacheComments(comments: [CommentDto]) {
        comments.forEach { commentDto in
            let comment = commentService.save(id: commentDto.id, postId: commentDto.postId, name: commentDto.name, body: commentDto.body)
            comment.post = self.post
        }
        storeManager.saveContext()
    }
    func getCommentsFromStore() {
        performFetchRequest()
        let comments = self.fetchedResultsController.fetchedObjects ?? []
        if comments.isEmpty {
            getCommentsHttp()
        }
    }
    func toggleFavorite() {
        _ = postService.toggleIsFavorite(post: post)
        storeManager.saveContext()
    }
    // MARK: - UI
    func updateUserInfoUi() {
        self.userNameLabel.text = self.post.user?.name
        self.userEmailLabel.text = self.post.user?.email
        self.userWebLabel.text = self.post.user?.website
        self.userPhoneLabel.text = self.post.user?.phone
    }
    func updateStarIconUi() {
        self.starButton.image = self.post.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    // MARK: - UI Events
    @IBAction func toggleFavorite(_ sender: Any) {
        self.toggleFavorite()
        self.updateStarIconUi()
    }
    // MARK: - Requests
    func getCommentsHttp() {
        NetworkService.shared.makeAGet(url: Constants.COMMENTS_ENDPOINT(postId: post.id.description), enableLoading: true) { (comments: [CommentDto]) in
            self.cacheComments(comments: comments)

        } onError: { (error: String) in
            self.showAlert(title: "Try again", message: error)
        } onComplete: {}

    }
    
    func getUserHttp() {
        NetworkService.shared.makeAGet(url: Constants.USER_ENDPOINT(userId: post.userId.description), enableLoading: true) { (user: UserDto) in
            self.cacheUser(user: user)
            self.updateUserInfoUi()
        } onError: { (error: String) in
            self.showAlert(title: "Try again", message: error)
        } onComplete: {}

    }
}
