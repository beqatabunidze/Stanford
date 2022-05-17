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
    
    weak var delegate: CardPresenterProtocol?
    
    private var concentration: Concentration
    
    
    func displayLabelValues() {
        
        delegate?.setLabels("Score: \(concentration.score)",
                            "Flips: \(concentration.flipsCount)")
        
    }
    
    init(delegate: CardPresenterProtocol, concentration: Concentration) {
        self.delegate = delegate
        self.concentration = concentration
    }
    
}
