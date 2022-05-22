//
//  PostsViewControllerTests.swift
//  ZemogaMobileTests
//
//  Created by Luci on 21/5/22.
//

import UIKit
import XCTest
@testable import ZemogaMobile


class PostsViewControllerTests: XCTestCase {

    var viewController: PostsViewController!
    var storeManager: StoreManager!
    var inMemoryContainer = MockPersistantContainer()
    var postService: PostService!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "PostsController") as! PostsViewController)
        storeManager = StoreManager(container: inMemoryContainer.mockPersistantContainer)
        postService = PostService(storeManager: storeManager)
        viewController.storeManager = storeManager
        _ = viewController.view
    }

    override func tearDownWithError() throws {
        cleanAll()
    }

    func testCachePosts() throws {
        viewController.cachePosts(postsDto: [PostDto(id: 500, userId: 1, title: "Cache post", body: "Cache post's body")])
        let postsStored = postService.fetchAll()
        XCTAssertEqual(postsStored.count, 1)
    }
    
    func testDeletePosts() {
        viewController.deletePosts()
        XCTAssertEqual(viewController.fetchedResultsController.fetchedObjects?.count, 0)
    }
    
    func testToggleEmptyLabelWithoutPosts() {
        viewController.segmentControl.selectedSegmentIndex = 0
        viewController.deletePosts()
        viewController.toggleEmptyLabel()
        XCTAssertEqual(Constants.EMPTY_POSTS, viewController.emptyLabel.text)
        XCTAssertTrue(viewController.view.subviews.contains(viewController.emptyLabel))
    }

    func testToggleEmptyLabelWithoutFavoritePosts() {
        viewController.segmentControl.selectedSegmentIndex = 1
        viewController.deletePosts()
        viewController.toggleEmptyLabel()
        XCTAssertEqual(Constants.EMPTY_FAVORITE_LIST, viewController.emptyLabel.text)
        XCTAssertTrue(viewController.view.subviews.contains(viewController.emptyLabel))
    }
    
    func testToggleEmptyLabelWithPosts() {
        
        viewController.cachePosts(postsDto: [PostDto(id: 500, userId: 1, title: "Cache post", body: "Cache post's body")])
        viewController.toggleEmptyLabel()
        XCTAssertFalse(viewController.view.subviews.contains(viewController.emptyLabel))
    }
    
    func testToggleSegmentChange() {
        _ = viewController.postService.save(id: 600, userId: 1, body: "Body", title: "Title", favorite: true)
        _ = viewController.postService.save(id: 601, userId: 1, body: "Body 2", title: "Title 2", favorite: false)
        viewController.toggleSegmentChange(selectedSegmentIndex: 1)
        XCTAssertEqual(viewController.fetchedResultsController.fetchedObjects?.count, 1)
    }
    
    func cleanAll() {
        postService.fetchAll().forEach({ post in
        postService.delete(post: post)
        })
    }
                          
                          
}
