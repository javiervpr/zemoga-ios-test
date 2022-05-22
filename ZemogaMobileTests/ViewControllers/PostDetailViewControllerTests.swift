//
//  PostDetailViewControllerTests.swift
//  ZemogaMobileTests
//
//  Created by Luci on 21/5/22.
//

import XCTest
import UIKit
@testable import ZemogaMobile

class PostDetailViewControllerTests: XCTestCase {
    
    var viewController: PostDetailViewController!
    var storeManager: StoreManager!
    var inMemoryContainer = MockPersistantContainer()
    var postService: PostService!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController)
        storeManager = StoreManager(container: inMemoryContainer.mockPersistantContainer)
        postService = PostService(storeManager: storeManager)
        viewController.storeManager = storeManager
        initStub()
        _ = viewController.view
    }

    override func tearDownWithError() throws {
       
    }

    func testToggleFavorite() throws {
        viewController.toggleFavorite()
        XCTAssertFalse(viewController.post.favorite)
    }

    func testUpdateFavoriteUiTrue() {
        viewController.updateStarIconUi()
        XCTAssertEqual(viewController.starButton.image, UIImage(systemName: "star.fill"))
    }
    
    func testUpdateFavoriteUiFalse() {
        viewController.toggleFavorite()
        viewController.updateStarIconUi()
        XCTAssertEqual(viewController.starButton.image, UIImage(systemName: "star"))
    }
    
    func testCacheUser() {
        viewController.cacheUser(user: UserDto(id: 400, name: "Carlos", email: "carlos@em.com", phone: "79833123", website: "www.carlos.com"))
        let userCreated = viewController.userService.fetchUserById(userId: 400)
        XCTAssertEqual(userCreated?.id, 400)
        XCTAssertEqual(userCreated?.name, "Carlos")
        XCTAssertEqual(userCreated?.email, "carlos@em.com")
        XCTAssertEqual(userCreated?.phone, "79833123")
        XCTAssertEqual(userCreated?.website, "www.carlos.com")
    }
    
    func testCacheComments() {
        let comments = [
            CommentDto(id: 500, postId: Int(viewController.post.id), name: "Greco", body: "Greco's comment"),
            CommentDto(id: 501, postId: Int(viewController.post.id), name: "Lucia", body: "Lucia's comment")
        ]
        viewController.cacheComments(comments: comments)
        let commentsByPost = viewController.commentService.fetchAllByPost(postId: Int(viewController.post.id))
        XCTAssertEqual(commentsByPost.count, comments.count)
        XCTAssertEqual(commentsByPost.first?.body, comments.first?.body)
    }
    
    func testCellRowAtIndexPath() {
        let comments = [
            CommentDto(id: 500, postId: Int(viewController.post.id), name: "Greco", body: "Greco's comment")
        ]
        viewController.cacheComments(comments: comments)
        let indexPath = NSIndexPath(row: 0, section: 0)
        let cell = viewController.commentTableView.dataSource?.tableView(viewController.commentTableView, cellForRowAt: indexPath as IndexPath) as! CommentCell
        XCTAssertEqual(cell.commentLabel.text, comments.first?.body)
    }
    
    func testNumberOfRows() {
        let comments = [
            CommentDto(id: 500, postId: Int(viewController.post.id), name: "Greco", body: "Greco's comment")
        ]
        viewController.cacheComments(comments: comments)
        let rows = viewController.commentTableView.dataSource?.tableView(viewController.commentTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, comments.count)
    }
    
    func initStub() {
        viewController.post = postService.save(id: 100, userId: 1, body: "Post's body", title: "Post's title", favorite: true)
        
    }
   

}
