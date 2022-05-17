//
//  CardsViewController.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 21.04.22.
//

import UIKit

class CardsViewController: UIViewController {
    
    private var flipLabel = UILabel()
    private var scoreLabel = UILabel()
    
    private var newGameButton = CustomButton()
    private var emojiButtonArr = [CustomButton]()
    
    private var cardsAndEmojisMap = [Card : String]()
    
    private var pickedTheme: Theme!
    
    private var stackHorizontalButtons = [UIStackView]()
    private var stackOfLabels = UIStackView()
    private var stackOfVerticalButtons = UIStackView()
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private lazy var concentration = Concentration(numberOfPairs: (emojiButtonArr.count / 2))
    
    private var presenter: CardPresenter?
    
    override func loadView() {
        setupLayout()
    }
    
    private func setupLabelConstraints(_ label: UILabel, _ text: String) {

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = true;
        label.adjustsFontForContentSizeCategory = true
        label.font = scoreLabel.font.withSize(35)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
    }
    
    private func setupStackConstraints(_ stack: UIStackView, _ axis: NSLayoutConstraint.Axis) {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = axis
        stack.alignment = .fill
        stack.contentMode = .scaleToFill
        stack.spacing = 10
        
    }
    
    private func setupLayout() {
        
        view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.isOpaque = false
        
        setupLabelConstraints(scoreLabel, "Score:\(0)")
        setupLabelConstraints(flipLabel, "Flips:\(0)")
        setupStackConstraints(stackOfLabels, .horizontal)
        stackOfLabels.addArrangedSubview(flipLabel)
        stackOfLabels.addArrangedSubview(scoreLabel)
        
        for _ in 0..<4 {
            let hstack = UIStackView()
            setupStackConstraints(hstack, .horizontal)
            stackHorizontalButtons.append(hstack)
        }
        
        let newGameButtonWidth = 160
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.isUserInteractionEnabled = true
        newGameButton.setTitle("New Game", for: .normal)
        
        for _ in 0..<16 {
            
            let emojiButton = CustomButton()
            emojiButton.isUserInteractionEnabled = true
            emojiButton.setTitle("1", for: .normal)
            emojiButtonArr.append(emojiButton)
        }
        
        for i in 0..<emojiButtonArr.count {
            
            emojiButtonArr[i].translatesAutoresizingMaskIntoConstraints = false
            emojiButtonArr[i].isUserInteractionEnabled = true
            emojiButtonArr[i].setTitle("", for: .normal)
            emojiButtonArr[i].titleLabel?.font = UIFont(name: "GillSans-Italic", size: 50)
            
        }
        
        for a in 0..<4 {
            stackHorizontalButtons[0].addArrangedSubview(emojiButtonArr[a])
        }
        for b in 4..<8 {
            stackHorizontalButtons[1].addArrangedSubview(emojiButtonArr[b])
        }
        for c in 8..<12 {
            stackHorizontalButtons[2].addArrangedSubview(emojiButtonArr[c])
        }
        for d in 12..<16 {
            stackHorizontalButtons[3].addArrangedSubview(emojiButtonArr[d])
        }
        
        setupStackConstraints(stackOfVerticalButtons, .vertical)
        
        for hstackItem in 0..<4 {
            stackOfVerticalButtons.addArrangedSubview( stackHorizontalButtons[hstackItem])
        }
        
        view.addSubview(newGameButton)
        view.addSubview(stackOfLabels)
        view.addSubview(stackOfVerticalButtons)
        
        sharedConstraints.append(contentsOf: [
            
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: CGFloat(newGameButtonWidth)),
            
            stackOfLabels.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            stackOfLabels.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            stackOfLabels.heightAnchor.constraint(equalToConstant: 42),
            stackOfLabels.topAnchor.constraint(greaterThanOrEqualTo: stackOfVerticalButtons.bottomAnchor, constant: 16),
            stackOfVerticalButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        compactConstraints.append(contentsOf: [
            stackOfVerticalButtons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            newGameButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -10),
            stackOfVerticalButtons.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 16),
            stackOfLabels.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -30),
            stackOfVerticalButtons.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -16),
            
        ])
        
        regularConstraints.append(contentsOf: [
            
            stackOfVerticalButtons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -5),
            newGameButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 35.0),
            stackOfVerticalButtons.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 100),
            stackOfVerticalButtons.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            stackOfLabels.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -15)
            
        ])
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        if (!sharedConstraints[0].isActive) {
            
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            
            NSLayoutConstraint.activate(compactConstraints)
            
        } else {
            
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CardPresenter(delegate: self, concentration: concentration)
        setTheme()
        setupButtons()
        traitCollectionDidChange( UIScreen.main.traitCollection)
        
    }
    
    private func setupButtons() {
        
        addActionToNewGameButton(with: newGameButton)
        
        for button in 0..<16 {
            addActionToEmojiGameButton(with: emojiButtonArr[button])
        }
    }
    
    internal func addActionToNewGameButton(with button : CustomButton) {
        button.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    }
    
    private func addActionToEmojiGameButton(with button : CustomButton) {
        button.addTarget(self, action: #selector(emojiGameButtonTapped), for: .touchUpInside)
    }
    
    @objc private func newGameButtonTapped(sender :CustomButton!) {
        
        setTheme()
        concentration.resetGame()
        displayCards()
        presenter?.displayLabelValues()
        
    }
    
    @objc private func emojiGameButtonTapped(sender :CustomButton!) {
        
        guard let index = emojiButtonArr.firstIndex(of: sender) else { return }
        concentration.flipCard(at: index)
        
        displayCards()
        presenter?.displayLabelValues()

    }
}

extension CardsViewController: CardPresenterProtocol {
    
    
    func setTheme() {
        
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
    
    func setLabels(_ scoreLabel: String, _ flipLabel: String) {
        self.scoreLabel.text = scoreLabel
        self.flipLabel.text = flipLabel
    }
}
