//
//  FavoriteButton.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/24/25.
//

import Foundation
import UIKit

class FavoriteButton: UIButton {
    @IBOutlet weak private var button: UIButton!
    
    private var isFavorited = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        if let nibView = bundle.loadNibNamed("FavoriteButton", owner: self)?.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    @IBAction func toggleFavorite() {
        isFavorited = !isFavorited
        
        button.setTitle(isFavorited ? "★" : "☆", for: .normal)
    }
}
