//
//  PostCell.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
  
    func setUpCell(title: String, isFavorite: Bool) {
        self.title.text = title
        self.rightImageView.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }

}
