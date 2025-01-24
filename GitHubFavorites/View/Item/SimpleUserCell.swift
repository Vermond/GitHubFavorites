//
//  SimpleUserCell.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import UIKit
import Kingfisher

class SimpleUserCell: UITableViewCell {
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var favoriteButton: FavoriteButton!
    
    private var userId: Int64 = 0
    private var userName: String = ""
    private var imgPath: String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        if let nibView = bundle.loadNibNamed("SimpleUserCell", owner: self)?.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    func favoriteButtonTapped() {
        if favoriteButton.isFavorited {
            guard let data = StorageController.shared.fetchUserData(withId: userId).first else { return }
            StorageController.shared.deleteUserData(userData: data)
            
            favoriteButton.setFavorite(to: false)
        } else {
            StorageController.shared.createUserData(userId: userId, name: userName, imgPath: imgPath)
            
            favoriteButton.setFavorite(to: true)
        }
    }
    
    func setData(data: GitHubUser) {
        userNameLabel.text = data.login
        
        let url = URL(string: data.avatar_url)
        profileImage.kf.setImage(with: url)
                
        self.userId = Int64(data.id)
        self.userName = data.login
        self.imgPath = data.avatar_url
        
        favoriteButton.setFavorite(to: !StorageController.shared.fetchUserData(withId: userId).isEmpty)
        
        favoriteButton.setOnTapped { [weak self] in
            self?.favoriteButtonTapped()
        }
    }
    
    func setData(data: UserData) {
        userNameLabel.text = data.userName
        
        if let url = URL(string: data.imgPath ?? "") {
            profileImage.kf.setImage(with: url)
        }
        
        self.userId = data.userId
        self.userName = data.userName ?? ""
        self.imgPath = data.imgPath ?? ""
        
        favoriteButton.setFavorite(to: true)
        
        favoriteButton.setOnTapped { [weak self] in
            self?.favoriteButtonTapped()
        }
    }
}
