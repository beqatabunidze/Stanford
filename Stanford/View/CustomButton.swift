//
//  CustomButton.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 27.04.22.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setShadow()
        setTitleColor(.white, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 30)
        layer.cornerRadius   = 10
        layer.borderWidth    = 3.0
        layer.borderColor    = UIColor.white.cgColor
    }
    
    private func setShadow() {
        layer.shadowColor   = UIColor.white.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }

}
