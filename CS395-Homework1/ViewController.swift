//
//  ViewController.swift
//  CS395-Homework1
//
//  Created by Panda on 9/21/14.
//  Copyright (c) 2014 Panda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var cashLabel: UILabel!
    @IBOutlet var playerCardsLabel: UILabel!
    @IBOutlet var dealerCardsLabel: UILabel!
    @IBOutlet var stayButton: UIButton!
    @IBOutlet var hitButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    var game = BlackjackGame()
    var midgame = false
    
    func updateUI() {
        var playerCardsString = ""
        for var i = 0; i < game.playerCards.count; ++i {
            playerCardsString += "\(game.playerCards[i].valueString) of \(game.playerCards[i].suitString)\n"
        }
        playerCardsLabel.text = playerCardsString
        dealerCardsLabel.text = ""
        
        cashLabel.text = "Cash: $\(String(game.playerCash))"
        
        //App just started
        if game.gameStatus == 0 {
            statusLabel.text = "Press Start Game to begin"
            startButton.enabled = true
            stayButton.enabled = false
            hitButton.enabled = false
        }
        //Middle of a round
        else if game.gameStatus == 1 {
            statusLabel.text = ""
            
            dealerCardsLabel.text = "\(game.dealerCards[0].valueString) of \(game.dealerCards[0].suitString)"
            
            startButton.enabled = false
            stayButton.enabled = true
            hitButton.enabled = true
        }
        //Round ended in either win or loss
        else if game.gameStatus == 2 {
            startButton.setTitle("Deal Again", forState: UIControlState.Normal)
            if game.playerWon { statusLabel.text = "Player wins!" }
            else { statusLabel.text = "Dealer wins!" }
            
            var dealerCardsString = ""
            for var i = 0; i < game.dealerCards.count; ++i {
                dealerCardsString += "\(game.dealerCards[i].valueString) of \(game.dealerCards[i].suitString)\n"
            }
            dealerCardsLabel.text = dealerCardsString
            
            startButton.enabled = true
            stayButton.enabled = false
            hitButton.enabled = false
            
        }
        //Player runs out of money
        else if game.gameStatus == 3 {
            startButton.setTitle("New Game", forState: UIControlState.Normal)
            statusLabel.text = "No more money! Play again?"
            startButton.enabled = true
            stayButton.enabled = false
            hitButton.enabled = false
        }
    }
    
    @IBAction func startTapped(sender: AnyObject) {
        if game.gameStatus == 2 {
            game.newRound()
        } else {
            game.newGame()
        }
        updateUI()
    }
    
    @IBAction func hitTapped(sender: AnyObject) {
        game.playerHit()
        updateUI()
    }
    
    @IBAction func stayTapped(sender: AnyObject) {
        game.playerStay()
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerCardsLabel.numberOfLines = 0 //0 = infinite number of lines
        dealerCardsLabel.numberOfLines = 0
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

