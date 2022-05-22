//
//  PostService.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import CoreData

class PostService {
    
    var storeManager: StoreManager!
    
    init(storeManager: StoreManager) {
        self.storeManager = storeManager
    }
    
    func save(id: Int, userId: Int, body: String, title: String, favorite: Bool = false) -> Post {
        let postModel = NSEntityDescription.insertNewObject(forEntityName: Post.entityName, into: storeManager.persistentContainer.viewContext) as! Post
        postModel.id = Int64(id)
        postModel.userId = Int64(userId)
        postModel.body = body
        postModel.title = title
        postModel.favorite = favorite
        return postModel
    }
    
    func delete(post: Post) {
        storeManager.persistentContainer.viewContext.delete(post)
    }
    
    func toggleIsFavorite(post: Post) -> Bool {
        post.favorite = !post.favorite
        return post.favorite
    }
    
    func fetchAll() -> [Post] {
        let fetchPost = NSFetchRequest<Post>(entityName: Post.entityName)
        fetchPost.sortDescriptors = [ NSSortDescriptor(key: #keyPath(Post.title), ascending: true) ]
        do {
            return try storeManager.persistentContainer.viewContext.fetch(fetchPost)
            
        } catch {
            fatalError("Error fetching posts")
        }
    }
    
    func fetchPostById(postId: Int) -> Post? {
        let fecthPost = NSFetchRequest<Post>(entityName: Post.entityName)
        fecthPost.predicate = NSPredicate(format: "id == %ld", postId)
        do {
            let result = try storeManager.persistentContainer.viewContext.fetch(fecthPost)
            if (result.isEmpty) {
                return nil
            } else {
                return result.first
            }
            
        } catch {
            fatalError("Error fetching post")
        }
    }
}
