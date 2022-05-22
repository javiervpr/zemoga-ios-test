//
//  PostsViewController.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import UIKit
import CoreData

class PostsViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var postTableView: UITableView!
    var storeManager = StoreManager()
    var postService: PostService!
    var fetchedResultsController: NSFetchedResultsController<Post>!
    let refreshControl = UIRefreshControl()
    let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postService = PostService(storeManager: storeManager)
        
        self.postTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        
        self.setupFetchController()
        self.getPostsFromStore()
    }
    
    //MARK: - UI
    func toggleEmptyLabel() {
        let posts = fetchedResultsController.fetchedObjects ?? []
        if posts.isEmpty {
            let emptyMessage = self.segmentControl.selectedSegmentIndex == 0 ? Constants.EMPTY_POSTS : Constants.EMPTY_FAVORITE_LIST
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyLabel.textAlignment = .center
            emptyLabel.text = emptyMessage
            self.view.addSubview(emptyLabel)
            
            view.addConstraint(NSLayoutConstraint(item: emptyLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: emptyLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))

        }
        else {
            emptyLabel.removeFromSuperview()
        }
    }
    
    func toggleSegmentChange(selectedSegmentIndex: Int) {
        if (selectedSegmentIndex == 0) {
            self.fetchedResultsController.fetchRequest.predicate = nil
            self.performFetchRequest()
        } else {
            let filterPredicate = NSPredicate(format: "favorite == TRUE")
            self.fetchedResultsController.fetchRequest.predicate = filterPredicate
            self.performFetchRequest()
        }
    }
    //MARK: - UI Events
    @IBAction func clickDeleteAll(_ sender: Any) {
        deletePosts()
        toggleEmptyLabel()
    }
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        self.toggleSegmentChange(selectedSegmentIndex: sender.selectedSegmentIndex)
        self.toggleEmptyLabel()
        self.postTableView.reloadData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        deletePosts()
        self.getPostFromHttp()
    }
    
    //MARK: - HttpRequests
    func getPostFromHttp() {
        NetworkService.shared.makeAGet(url: Constants.POST_ENDPOINT, enableLoading: true) { (posts: [PostDto]) in
            self.cachePosts(postsDto: posts)
        } onError: { (error: String) in
            self.showAlert(title: "Try again", message: error)
        
        } onComplete: {
            self.refreshControl.endRefreshing()
            self.toggleEmptyLabel()
        }
    }
    //MARK: - Core data
    func getPostsFromStore() {
        performFetchRequest()
        let posts = self.fetchedResultsController.fetchedObjects ?? []
        if posts.isEmpty {
            getPostFromHttp()
        }
    }
    
    func cachePosts(postsDto: [PostDto]) {
        postsDto.forEach { postDto in
            _ = postService.save(id: postDto.id, userId: postDto.userId, body: postDto.body, title: postDto.title)
            storeManager.saveContext()
        }
    }
    func deletePosts() {
        guard let posts = self.fetchedResultsController.fetchedObjects else { return }
        posts.forEach { post in
            postService.delete(post: post)
        }
        storeManager.saveContext()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PostDetailViewController {
            guard let posts = self.fetchedResultsController.fetchedObjects else { return }
            let destination: PostDetailViewController = segue.destination as! PostDetailViewController
            destination.post = posts[sender as! Int]
        }
    }
    
}
