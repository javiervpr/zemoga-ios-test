//
//  CommentCell.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!

    func setUpCell(comment: String) {
        self.commentLabel.text = comment
    }

}
