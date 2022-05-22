//
//  PostViewController+TableViewDelegate.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import UIKit
import CoreData

// MARK: - TableViewDataSource and TableViewDelegate
extension PostsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PostCell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else { return UITableViewCell() }
        let post = self.fetchedResultsController.object(at: indexPath)
        cell.setUpCell(title: post.title!,isFavorite: post.favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PostDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
