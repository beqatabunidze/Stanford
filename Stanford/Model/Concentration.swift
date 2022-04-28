//
//  Concentration.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 26.04.22.
//

import Foundation
import GameplayKit

protocol ConcentrationDelegate {

  func didMatchCards(withIndices indices: [Int])
    
}

class Concentration {
    
  private(set) var cards = [Card]()
    
  private var oneAndOnlyFlippedCardIndex: Int? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
    }
    set {
        
      setCurrentPairToFaceDown()
      scoringDate = Date()
    }
  }

  private(set) var flipsCount = 0
    
  private var scoringDate: Date?
    
  private(set) var score = 0

  private var currentPairIndices: [Int]?
  
  var delegate: ConcentrationDelegate?
  
  init(numberOfPairs: Int) {
    setPairs(withCount: numberOfPairs)
  }
    
  func resetGame() {
    flipsCount = 0
    score = 0
    
    Card.resetIdentifiersCount()
    let pairsCount = cards.count / 2
    cards = []
    currentPairIndices = nil
    setPairs(withCount: pairsCount)
  }
    
  private func setPairs(withCount numberOfPairs: Int) {
    for _ in 0..<numberOfPairs {
      let currentCard = Card()
      
      cards.append(currentCard)
      cards.append(currentCard)
    }
      
      cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
  }
  
  func flipCard(at index: Int) {
    var selectedCard = cards[index]
    
    guard !selectedCard.isMatched else { return }

    if let currentPairIndices = currentPairIndices {
      delegate?.didMatchCards(withIndices: currentPairIndices)
      self.currentPairIndices = nil
    }
    
    if let firstCardIndex = oneAndOnlyFlippedCardIndex, firstCardIndex != index {
      
      var firstCard = cards[firstCardIndex]
      
      // Do we have a match?
      if firstCard == selectedCard {
        firstCard.isMatched = true
        selectedCard.isMatched = true
        increaseScore()
        
        currentPairIndices = [firstCardIndex, index]
      }
      
      cards[firstCardIndex] = firstCard
    } else {
      // We don't have a single flipped card, it's time to set one.
      oneAndOnlyFlippedCardIndex = index
    }
    
    selectedCard.flipCard()
    
    flipsCount += 1
    cards[index] = selectedCard
  }

  private func removeMatchedPair() {
      
    let matchedCards = cards.filter { $0.isMatched }
    
    guard !matchedCards.isEmpty else { return }
    
    for card in matchedCards {
      if let index = cards.firstIndex(of: card) {
        cards.remove(at: index)
      }
    }
  }
    
  private func setCurrentPairToFaceDown() {
      
    var didPenalize = false
    
    for cardIndex in cards.indices {
      var currentCard = cards[cardIndex]
      
      if currentCard.isFaceUp {

        if currentCard.hasBeenFlipped && !currentCard.isMatched && !didPenalize {
          penalize()
            
          didPenalize = true
        }
        
        currentCard.hasBeenFlipped = true
        currentCard.setFaceDown()
      }
      
      cards[cardIndex] = currentCard
    }
  }
    
  private func increaseScore() {
    
    if let scoringDate = scoringDate {
      let secondsBetweenFlips = Int(Date().timeIntervalSince(scoringDate))
      
      if secondsBetweenFlips < 2 {
        score += 3
      } else {
        score += 2
      }
      self.scoringDate = nil
    } else {
      score += 2
    }
      
  }
    
  private func penalize() {
    score -= 1
  }
}

extension Collection {
    
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
  
}
