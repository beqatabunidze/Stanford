//
//  CardsViewController.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 21.04.22.
//

import UIKit

class CardsViewController: UIViewController {
    
    var flipLabel : UILabel!
    var scoreLabel : UILabel!
    
    var newGameButton : CustomButton!
    var emojiButtonArr : [CustomButton]!
    
    var hStackArr : [UIStackView]!
    var hStack1 : UIStackView!
    var vStack1 : UIStackView!
    
    var newGameButton1 : CustomButton!
    var newGameButton2 : CustomButton!
    var newGameButton3 : CustomButton!
    var newGameButton4 : CustomButton!
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private lazy var concentration = Concentration(numberOfPairs: (emojiButtonArr.count / 2))
    private var cardsAndEmojisMap = [Card : String]()
    
    private lazy var presenter = CardPresenter(delegate: self,
                                               newGameButton: self.newGameButton,
                                               emojiButtonArr: self.emojiButtonArr,
                                               concentration: self.concentration,
                                               cardsAndEmojiMap: self.cardsAndEmojisMap
    )
    
    override func loadView() {
        setupLayout()
    }
    
    private func setupLayout() {
        
        view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.isOpaque = false
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score:\(0)"
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1;
        scoreLabel.adjustsFontSizeToFitWidth = true;
        scoreLabel.adjustsFontForContentSizeCategory = true
        scoreLabel.font = scoreLabel.font.withSize(35)
        scoreLabel.textColor = .white
        
        flipLabel = UILabel()
        flipLabel.translatesAutoresizingMaskIntoConstraints = false
        flipLabel.text = "Flips:\(0)"
        flipLabel.textAlignment = .center
        flipLabel.numberOfLines = 1;
        flipLabel.adjustsFontSizeToFitWidth = true;
        flipLabel.font = flipLabel.font.withSize(35)
        flipLabel.textColor = .white
        
        flipLabel.adjustsFontForContentSizeCategory = true
        
        hStack1 = UIStackView()
        hStack1.translatesAutoresizingMaskIntoConstraints = false
        hStack1.distribution = .fillEqually
        hStack1.axis = .horizontal
        hStack1.alignment = .fill
        hStack1.contentMode = .scaleToFill
        hStack1.addArrangedSubview(flipLabel)
        hStack1.addArrangedSubview(scoreLabel)
        
        hStackArr = [UIStackView]()
        
        for _ in 0..<4 {
            let hstack = UIStackView()
            hstack.translatesAutoresizingMaskIntoConstraints = false
            hstack.distribution = .fillEqually
            hstack.axis = .horizontal
            hstack.alignment = .fill
            hstack.contentMode = .scaleToFill
            hstack.spacing = 10
            hStackArr.append(hstack)
        }
        
        let newGameButtonWidth = 160
        newGameButton = CustomButton()
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.isUserInteractionEnabled = true
        newGameButton.setTitle("New Game", for: .normal)
        
        emojiButtonArr = [CustomButton]()
        
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
            hStackArr[0].addArrangedSubview(emojiButtonArr[a])
        }
        for b in 4..<8 {
            hStackArr[1].addArrangedSubview(emojiButtonArr[b])
        }
        for c in 8..<12 {
            hStackArr[2].addArrangedSubview(emojiButtonArr[c])
        }
        for d in 12..<16 {
            hStackArr[3].addArrangedSubview(emojiButtonArr[d])
        }
        
        vStack1 = UIStackView()
        vStack1.translatesAutoresizingMaskIntoConstraints = false
        vStack1.distribution = .fillEqually
        vStack1.axis = .vertical
        vStack1.alignment = .fill
        vStack1.contentMode = .scaleToFill
        vStack1.spacing = 10
        
        for hstackItem in 0..<4 {
            vStack1.addArrangedSubview( hStackArr[hstackItem])
        }
        
        view.addSubview(newGameButton)
        view.addSubview(hStack1)
        view.addSubview(vStack1)
        
        sharedConstraints.append(contentsOf: [
            
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: CGFloat(newGameButtonWidth)),
            
            hStack1.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            hStack1.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            hStack1.heightAnchor.constraint(equalToConstant: 42),
            hStack1.topAnchor.constraint(greaterThanOrEqualTo: vStack1.bottomAnchor, constant: 16),
            vStack1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        compactConstraints.append(contentsOf: [
            vStack1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            newGameButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -10),
            vStack1.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 16),
            hStack1.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -30),
            vStack1.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -16),
            
        ])
        
        regularConstraints.append(contentsOf: [
            
            vStack1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -5),
            newGameButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 35.0),
            vStack1.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,constant: 100),
            vStack1.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            hStack1.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -15)
            
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
        
        presenter.chooseRandomTheme()
        presenter.setButtonActions()
        traitCollectionDidChange( UIScreen.main.traitCollection)
        
    }
    
}

extension CardsViewController: CardPresenterDelegate {
    func setLabels(_ scoreLabel: String, _ flipLabel: String) {
        self.scoreLabel.text = scoreLabel
        self.flipLabel.text = flipLabel
    }
    

}
