//
//  PostServiceTests.swift
//  ZemogaMobileTests
//
//  Created by Luci on 20/5/22.
//

import XCTest
@testable import ZemogaMobile

class PostServiceTests: XCTestCase {

    var storeManager: StoreManager!
    var inMemoryContainer = MockPersistantContainer()
    var postService: PostService!
    
    override func setUpWithError() throws {
        storeManager = StoreManager(container: inMemoryContainer.mockPersistantContainer)
        postService = PostService(storeManager: storeManager)
        initStubs()
    }

    override func tearDownWithError() throws {
        cleanStubs()
    }

    func testFetchAll() throws {
        let posts = postService.fetchAll()
        XCTAssertNotNil(posts)
        XCTAssertEqual(posts.count, 4)
        XCTAssertEqual(posts[0].body, "This is the body")
    }
    
    func testFetchById() {
        let post = postService.fetchPostById(postId: 100)
        XCTAssertNotNil(post)
        XCTAssertEqual(post?.body, "This is the body")
        XCTAssertEqual(post?.title, "Title")
    }
    
    func testFetchByInvalidId() {
        let post = postService.fetchPostById(postId: 1020)
        XCTAssertNil(post)
    }

    func testDelete() {
        let post = postService.fetchPostById(postId: 100)
        postService.delete(post: post!)
        let userDeleted = postService.fetchPostById(postId: 100)
        XCTAssertNil(userDeleted)
    }
    
    func testSave() {
        let result = postService.save(id: 400, userId: 1, body: "Body", title: "Title")
        let newPost = postService.fetchPostById(postId: 400)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.body, "Body")
        XCTAssertEqual(result.title, "Title")
        XCTAssertEqual(result, newPost)
    }
    
    func testToggleFavorite() {
        let post = postService.fetchPostById(postId: 100)
        let result = postService.toggleIsFavorite(post: post!)
        XCTAssertTrue(result)
    }

    func initStubs() {
        _ = postService.save(id: 100, userId: 1, body: "This is the body", title: "Title")
        _ = postService.save(id: 101, userId: 1, body: "This is the body 2", title: "Title 2")
        _ = postService.save(id: 102, userId: 1, body: "This is the body 3", title: "Title 3")
        _ = postService.save(id: 103, userId: 1, body: "This is the body 4", title: "Title 4")
    }
    
    func cleanStubs() {
        postService.fetchAll().forEach({ post in
            postService.delete(post: post)
        })
    }
    
}
