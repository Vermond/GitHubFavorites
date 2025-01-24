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
        
    private(set) var isFavorited = false
    private var onTapped: (() -> Void)? = nil
    
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
    
    public func setOnTapped(_ handler: @escaping () -> Void) {
        onTapped = handler
    }
    
    @IBAction func tapped(_ sender: Any) {
        onTapped?()
    }
    
    public func setFavorite(to value: Bool) {
        isFavorited = value
        
        button.setTitle(isFavorited ? "★" : "☆", for: .normal)
    }
}
