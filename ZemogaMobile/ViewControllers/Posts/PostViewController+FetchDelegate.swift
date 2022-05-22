//
//  PostViewController+FetchDelegate.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import CoreData

// MARK: - ResultsControllerDelegate
extension PostsViewController: NSFetchedResultsControllerDelegate {
    func setupFetchController() {
        let postFetchRequest = NSFetchRequest<Post>(entityName: Post.entityName)
        let favoriteSorter = NSSortDescriptor(key: #keyPath(Post.favorite), ascending: false)
        postFetchRequest.sortDescriptors = [favoriteSorter]
        
        self.fetchedResultsController = NSFetchedResultsController<Post>(fetchRequest: postFetchRequest,
                                                                         managedObjectContext: storeManager.persistentContainer.viewContext,
                                                                         sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
    }
    
    func performFetchRequest() {
        do {
            try self.fetchedResultsController.performFetch()
            
        } catch {
            self.showAlert(title: "Loading posts failed", message: "There was a problem loading the list of Posts. Please try again.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.postTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.postTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.postTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                self.postTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = self.postTableView.cellForRow(at: updateIndexPath) as? PostCell
                let updatedPost = self.fetchedResultsController.object(at: updateIndexPath)
                cell?.setUpCell(title: updatedPost.title!, isFavorite: updatedPost.favorite)
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.postTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.postTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        @unknown default:
            fatalError()
        }
    }
}
