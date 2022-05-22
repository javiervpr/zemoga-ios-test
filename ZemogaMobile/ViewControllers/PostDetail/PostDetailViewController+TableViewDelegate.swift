//
//  PostDetailViewController+TableViewDelegate.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import UIKit
import CoreData

// MARK: - TableViewDataSource and TableViewDelegate
extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell else { return UITableViewCell() }
        let comment = self.fetchedResultsController.object(at: indexPath)
        cell.setUpCell(comment: comment.body!)
        return cell
    }
}
