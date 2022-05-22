//
//  ZemogaMobileTests.swift
//  ZemogaMobileTests
//
//  Created by Luci on 17/5/22.
//

import XCTest
@testable import ZemogaMobile

class UserServiceTests: XCTestCase {

    var storeManager: StoreManager!
    var inMemoryContainer = MockPersistantContainer()
    var userService: UserService!
    
    override func setUpWithError() throws {
        storeManager = StoreManager(container: inMemoryContainer.mockPersistantContainer)
        userService = UserService(storeManager: storeManager)
        initUsersStub()
    }

    override func tearDownWithError() throws {
        cleanUsers()
    }

    func testSaveUser() throws {
        let user = userService.save(id: 401, name: "Roca", email: "javier@ex.com", phone: "76512341", web: "www.zemoga.com")
        
        let newUser = userService.fetchUserById(userId: 401)
        XCTAssertNotNil(user)
        XCTAssertEqual(user.name, "Roca")
        XCTAssertEqual(user.email, "javier@ex.com")
        XCTAssertEqual(user.phone, "76512341")
        XCTAssertEqual(user.website, "www.zemoga.com")
        XCTAssertEqual(user, newUser)
    }
    
    func testFetchAll() {
        let users = userService.fetchAll()
        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(users[0].name, "Esteban")
    }
    
    
    func testFetchById() {
        let user = userService.fetchUserById(userId: 100)
        XCTAssertNotNil(user)
        XCTAssertEqual(user!.name, "Juan")
    }
    
    func testFetchByInvalidId() {
        let user = userService.fetchUserById(userId: 1000)
        XCTAssertNil(user)
    }
    
    func testDelete() {
        let user = userService.fetchUserById(userId: 100)
        userService.delete(user: user!)
        let userDeleted = userService.fetchUserById(userId: 100)
        XCTAssertNil(userDeleted)
    }
    
    func initUsersStub() {
        _ = userService.save(id: 100, name: "Juan", email: "juan@ex.com", phone: "76512341", web: "www.zemoga.com")
        _ = userService.save(id: 101, name: "Pedro", email: "pedro@ex.com", phone: "6325241", web: "www.zemoga.com")
        _ = userService.save(id: 102, name: "Esteban", email: "esteban@ex.com", phone: "66512341", web: "www.zemoga.com")
    }
    
    func cleanUsers() {
        userService.fetchAll().forEach { user in
            userService.delete(user: user)
        }
    }


}
