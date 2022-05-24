//
//  CommentService.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import CoreData

class CommentService {
    
    var storeManager: StoreManager!
    
    init(storeManager: StoreManager) {
        self.storeManager = storeManager
    }
    
    func save(id: Int, postId: Int, name: String, body: String) -> Comment {
        let comment = NSEntityDescription.insertNewObject(forEntityName: Comment.entityName, into: storeManager.persistentContainer.viewContext) as! Comment
        comment.id = Int64(id)
        comment.postId = Int64(postId)
        comment.name = name
        comment.body = body
        return comment
    }
    
    func fetchAllByPost(postId: Int) -> [Comment] {
        let fetchComment = NSFetchRequest<Comment>(entityName: Comment.entityName)
        fetchComment.predicate = NSPredicate(format: "postId == %ld", postId)
        fetchComment.sortDescriptors = [ NSSortDescriptor(key: #keyPath(Comment.body) , ascending: true) ]
        do {
            return try storeManager.persistentContainer.viewContext.fetch(fetchComment)
            
        } catch {
            fatalError("Error fetching comments")
        }
    }
    
    func fetchCommentById(commentId: Int) -> Comment? {
        let fectchComment = NSFetchRequest<Comment>(entityName: Comment.entityName)
        fectchComment.predicate = NSPredicate(format: "id == %ld", commentId)
        do {
            let result = try storeManager.persistentContainer.viewContext.fetch(fectchComment)
            if (result.isEmpty) {
                return nil
            } else {
                return result.first
            }
            
        } catch {
            fatalError("Error fetching comment")
        }
    }
    
    func delete(comment: Comment) {
        storeManager.persistentContainer.viewContext.delete(comment)
    }
}
