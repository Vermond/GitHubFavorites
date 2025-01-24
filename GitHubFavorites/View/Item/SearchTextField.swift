//
//  SearchTextField.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/24/25.
//

import Foundation
import UIKit

class SearchTextField: UITextField {
    private var idleTimer: Timer?
    private var interval: Double = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        self.superview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleOutsideTap() {
        self.resignFirstResponder()
    }
    
    private func setup() {
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        resetIdleTimer()
    }
    
    private func resetIdleTimer() {
        idleTimer?.invalidate()
        
        idleTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(handleIdleTimeout), userInfo: nil, repeats: false)
    }
    
    @objc private func handleIdleTimeout() {
        self.resignFirstResponder()
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        
        return true
    }
}
