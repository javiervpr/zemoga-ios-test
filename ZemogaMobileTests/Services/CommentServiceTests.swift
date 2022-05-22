//
//  CommentService.swift
//  ZemogaMobileTests
//
//  Created by Luci on 20/5/22.
//

import XCTest
@testable import ZemogaMobile

class CommentServiceTests: XCTestCase {

    var storeManager: StoreManager!
    var inMemoryContainer = MockPersistantContainer()
    var commentService: CommentService!
    var postService: PostService!
    
    override func setUpWithError() throws {
        storeManager = StoreManager(container: inMemoryContainer.mockPersistantContainer)
        commentService = CommentService(storeManager: storeManager)
        postService = PostService(storeManager: storeManager)
        initStubs()
    }
    
    override func tearDownWithError() throws {
        cleanStubs()
    }

    func testFetchAllByPostId() throws {
        let comments = commentService.fetchAllByPost(postId: 100)
        XCTAssertNotNil(comments)
        XCTAssertEqual(comments.count, 3)
        XCTAssertEqual(comments[0].body, "Laura's comment")
    }
    
    func testFetchAllByInvalidPostId() throws {
        let comments = commentService.fetchAllByPost(postId: 10330)
        XCTAssertTrue(comments.isEmpty)
    }
    
    func testFetchById() {
        let comment = commentService.fetchCommentById(commentId: 200)
        XCTAssertNotNil(comment)
        XCTAssertEqual(comment?.body, "This is the comment's body")
        XCTAssertEqual(comment?.name, "Greco")
    }
    
    func testFetchByInvalidId() {
        let comment = commentService.fetchCommentById(commentId: 2021)
        XCTAssertNil(comment)
    }

    func testDelete() {
        let comment = commentService.fetchCommentById(commentId: 200)
        commentService.delete(comment: comment!)
        let commentDeleted = commentService.fetchCommentById(commentId: 200)
        XCTAssertNil(commentDeleted)
    }
    
    func testSave() {
        let result = commentService.save(id: 300, postId: 100, name: "Revel", body: "Revel's comment")
        let newComment = commentService.fetchCommentById(commentId: 300)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.body, "Revel's comment")
        XCTAssertEqual(result.name, "Revel")
        XCTAssertEqual(result, newComment)
    }



    func initStubs() {
        _ = postService.save(id: 100, userId: 1, body: "This is the body", title: "Title")
        _ = commentService.save(id: 200, postId: 100, name: "Greco", body: "This is the comment's body")
        _ = commentService.save(id: 201, postId: 100, name: "Laura", body: "Laura's comment")
        _ = commentService.save(id: 202, postId: 100, name: "Rochel", body: "Rochel's comment")
    }
    
    func cleanStubs() {
        let post = postService.fetchPostById(postId: 100)
        postService.delete(post: post!)
        
        commentService.fetchAllByPost(postId: 100).forEach { comment in
            commentService.delete(comment: comment)
        }
    }
}
