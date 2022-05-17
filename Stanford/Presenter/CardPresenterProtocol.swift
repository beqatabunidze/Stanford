//
//  CardPresenter.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 27.04.22.
//

import Foundation

protocol CardPresenterProtocol: AnyObject {
    
    func setLabels(_ scoreLabel: String, _ flipLabel: String)
    func setTheme()
    func displayCards()
}

final class CardPresenter {
    
    init(delegate: CardPresenterProtocol, concentration: Concentration) {
        self.delegate = delegate
        self.concentration = concentration
    }
    
    weak var delegate: CardPresenterProtocol?
    
    private var concentration: Concentration
    
    private var count: Int {
        return Theme.Fruit.rawValue + 1
    }
    
    func displayLabelValues() {
        
        delegate?.setLabels("Score: \(concentration.score)",
                            "Flips: \(concentration.flipsCount)")
        
    }
    
    func getRandom() -> Theme {
        return Theme(rawValue: self.count.arc4random)!
    }
    
    
}
