//
//  CardPresenter.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 27.04.22.
//

import Foundation

protocol CardPresenterDelegate: AnyObject {
    
    func setLabels(_ scoreLabel: String, _ flipLabel: String)
    
}

class CardPresenter {
    
    weak var delegate: CardPresenterDelegate?
    
    private var newGameButton : CustomButton!
    private var emojiButtonArr : [CustomButton]!
    
    private lazy var concentration = Concentration(numberOfPairs: (emojiButtonArr.count / 2))
    
    private var cardsAndEmojisMap = [Card : String]()
    
    private var pickedTheme: Theme!
    
    
    func displayCards() {
        
        for (index, cardButton) in emojiButtonArr.enumerated() {
            guard concentration.cards.indices.contains(index) else { continue }
            
            let card = concentration.cards[index]
            
            if card.isFaceUp {
                
                cardButton.setTitle(cardsAndEmojisMap[card], for: .normal)
                cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
            } else {
                
                cardButton.setTitle("", for: .normal)
                cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : pickedTheme.cardColor
            }
        }
    }
    
    func chooseRandomTheme() {
        
        pickedTheme = Theme.getRandom()
        cardsAndEmojisMap = [:]
        
        var emojis = pickedTheme.emojis
        
        for card in concentration.cards {
            if cardsAndEmojisMap[card] == nil {
                cardsAndEmojisMap[card] = emojis.remove(at: emojis.count.arc4random)
            }
        }
        
        displayCards()
    }
    
    func setButtonActions() {
        
        addActionToNewGameButton(with: newGameButton)
        
        for button in 0..<16 {
            addActionToEmojiGameButton(with: emojiButtonArr[button])
        }
    }
    
    func displayLabelValues() {
        
        delegate?.setLabels("Score: \(concentration.score)",
                            "Flips: \(concentration.flipsCount)")
        
    }
    
    func addActionToNewGameButton(with button : CustomButton) {
        button.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    }
    
    func addActionToEmojiGameButton(with button : CustomButton) {
        button.addTarget(self, action: #selector(emojiGameButtonTapped), for: .touchUpInside)
    }
    
    @objc func newGameButtonTapped(sender :CustomButton!) {
        
        chooseRandomTheme()
        concentration.resetGame()
        displayCards()
        displayLabelValues()
        
    }
    
    @objc func emojiGameButtonTapped(sender :CustomButton!) {
        
        guard let index = emojiButtonArr.firstIndex(of: sender) else { return }
        concentration.flipCard(at: index)
        
        displayCards()
        displayLabelValues()

    }
    
    init(delegate: CardPresenterDelegate, newGameButton: CustomButton, emojiButtonArr : [CustomButton], concentration: Concentration, cardsAndEmojiMap: [Card : String]) {
        self.delegate = delegate
        self.newGameButton = newGameButton
        self.emojiButtonArr = emojiButtonArr
        self.concentration = concentration
        self.cardsAndEmojisMap = cardsAndEmojiMap
    }
    
}
