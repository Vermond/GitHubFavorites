//
//  SimpleUserCell.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import UIKit

class SimpleUserCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    func setData(userName: String, imgPath: String) {
        userNameLabel.text = userName
    }
}
