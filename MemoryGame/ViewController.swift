//
//  ViewController.swift
//  MemoryGame
//
//  Created by albert tseng on 2019/8/4.
//  Copyright © 2019 albert tseng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var movesMade: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var hooray: UIView!
    
    var tsums = [Tsum]()
    var selectedTsums = [Int]()
    var moves = 0
    var currentHighScore = 0
    var pairsFound = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameInit()
    }
    
    func gameInit() -> Void {
        tsums.removeAll()
        tsums = [
            Tsum(name: "Mickey", image: UIImage(named: "Mickey")),
            Tsum(name: "Winnie", image: UIImage(named: "Winnie")),
            Tsum(name: "Winnie", image: UIImage(named: "Winnie")),
            Tsum(name: "Stich", image: UIImage(named: "Stich")),
            Tsum(name: "Stich", image: UIImage(named: "Stich")),
            Tsum(name: "Fox", image: UIImage(named: "Fox")),
            Tsum(name: "Fox", image: UIImage(named: "Fox")),
            Tsum(name: "BigHeroSix", image: UIImage(named: "BigHeroSix")),
            Tsum(name: "Elsa", image: UIImage(named: "Elsa")),
            Tsum(name: "Elsa", image: UIImage(named: "Elsa")),
            // Tsum(name: "Dumbo", image: UIImage(named: "Dumbo")),
            // Tsum(name: "Heart", image: UIImage(named: "Heart")),
            Tsum(name: "BigHeroSix", image: UIImage(named: "BigHeroSix")),
            Tsum(name: "Mickey", image: UIImage(named: "Mickey"))]
        
        tsums.shuffle()
        selectedTsums.removeAll()
        moves = 0
        displayCards()
        
    }

    struct Tsum {
        var name: String?
        var image: UIImage?
        var isFlipped: Bool = false
        var isAlive: Bool = true
        
    }
    
    func flipCardIndex(index: Int) -> Void {
        if tsums[index].isFlipped == true {
            cardButtons[index].setImage(UIImage(named: "Back.png"), for: .normal)
            UIView.transition(with: cardButtons[index], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            tsums[index].isFlipped = false
        } else {
            cardButtons[index].setImage(tsums[index].image, for: .normal)
            UIView.transition(with: cardButtons[index], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            tsums[index].isFlipped = true
        }
    }
    
    func disAbleCard(index: Int) -> Void {
        tsums[index].isAlive = false
        cardButtons[index].alpha = 0.4
        UIView.transition(with: cardButtons[index], duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func displayCards() -> Void {
        for (i,_) in cardButtons.enumerated() {
            if tsums[i].isAlive == true {
                if tsums[i].isFlipped == true {
                    cardButtons[i].setImage(tsums[i].image, for: .normal)
                } else {
                    cardButtons[i].setImage(UIImage(named: "Back.png"), for: .normal)
                }
            } else {
                
                cardButtons[i].setImage(tsums[i].image, for: .normal)
                cardButtons[i].alpha = 0.4

            }
        }
    }
    
/*
if no cards
    add that to selected card
    flip card

if 1 card
    compare if the card is the same as the one selected before
    if yes then flip back
    if no then add that to selected cards and flip card
        compare if these two cards' names are the same
        if yes then disable
        if no then flip these 2 cards to their backs
        remove these two cards from selected
 */
    @IBAction func flipCard(_ sender: UIButton) {
        
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            // check if the tsum is still alive
            if tsums[cardIndex].isAlive == false {
                return
            }
            
            if selectedTsums.count == 0 {
                selectedTsums.append(cardIndex)
                flipCardIndex(index: cardIndex)
            } else if selectedTsums.count == 1 {
                moves += 1
                movesMade.text = String(moves)
                if selectedTsums.contains(cardIndex) {
                    flipCardIndex(index: cardIndex)
                    selectedTsums.removeAll()
                } else {
                    selectedTsums.append(cardIndex)
                    flipCardIndex(index: cardIndex)
                    if tsums[selectedTsums[0]].name == tsums[selectedTsums[1]].name {
                        // disable
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (_) in
                            for (_,num) in self.selectedTsums.enumerated() {
                                self.disAbleCard(index: num)
                            }
                            self.selectedTsums.removeAll()
                            self.pairsFound += 1
                            if self.pairsFound == 6 {
                                print("game end")
                                self.hooray.isHidden = false
                                if self.currentHighScore == 0 || self.moves < self.currentHighScore {
                                    self.currentHighScore = self.moves
                                }
                                self.highScore.text = String(self.currentHighScore)
                            }
                        }
                        
                        
                    } else {
                        // flip them back
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (_) in
                            for (_,num) in self.selectedTsums.enumerated() {
                                self.flipCardIndex(index: num)
                            }
                            self.selectedTsums.removeAll()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func restart(_ sender: Any) {
        gameInit()
        movesMade.text = String(moves)
        pairsFound = 0
        hooray.isHidden = true
        for (i,_) in cardButtons.enumerated() {
            cardButtons[i].alpha = 1
        }
    }
}

