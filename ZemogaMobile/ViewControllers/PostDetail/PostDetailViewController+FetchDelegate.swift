//
//  PostDetailViewControllerFetchDelegate.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import CoreData

// MARK: - ResultsControllerDelegate
extension PostDetailViewController: NSFetchedResultsControllerDelegate {
    func setupFetchController() {
        let commentFetchRequest = NSFetchRequest<Comment>(entityName: Comment.entityName)
        let commentSorter = NSSortDescriptor(key: #keyPath(Comment.body), ascending: false)
        commentFetchRequest.sortDescriptors = [commentSorter]
        
        self.fetchedResultsController = NSFetchedResultsController<Comment>(fetchRequest: commentFetchRequest,
                                                                            managedObjectContext: storeManager.persistentContainer.viewContext,
                                                                         sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        let filterPredicate = NSPredicate(format: "post == %@", self.post)
        self.fetchedResultsController.fetchRequest.predicate = filterPredicate
    }
    func performFetchRequest() {
        do {
            try self.fetchedResultsController.performFetch()
            
        } catch {
            self.showAlert(title: "Loading comments failed", message: "There was a problem loading the list of comments. Please try again.")
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.commentTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.commentTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.commentTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                self.commentTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = self.commentTableView.cellForRow(at: updateIndexPath) as? CommentCell
                let updatedComment = self.fetchedResultsController.object(at: updateIndexPath)
                
                cell?.setUpCell(comment: updatedComment.body!)
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.commentTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.commentTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        @unknown default:
            fatalError()
        }
    }
}
