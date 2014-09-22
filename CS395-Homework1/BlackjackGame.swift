//
//  BlackjackModel.swift
//  CS395-Homework1
//
//  Created by Pan Chan on 9/21/14.
//

import Foundation

struct Card {
    var suit: Int
    var suitString: String
    var value: Int
    var valueString: String
}

class BlackjackGame {
    var gamesPlayed = 0
    var playerCash = 100
    var deck = [Card]()
    
    var dealer = 0
    var dealerCards = [Card]()
    
    var player = 0
    var playerCards = [Card]()
    
    var playerWon = false
    
    /*
    0 = App start: Disable hit/stay, enable new game.
    1 = Mid-round: player has not lost/won yet. Enable hit/stay, disable deal.
    2 = End-round: player lost/won. Disable hit/stay, enable deal.
    3 = Game over: player broke. Disable hit/stay, enable new game.
    */
    var gameStatus = 0
    
    func shuffleDeck() {
        deck = [Card]()
        for var i = 0; i < 4; ++i {
            var suitStrings = ["Diamonds", "Clubs", "Hearts", "Spades"]
            var valueStrings = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
            for var j = 1; j < 14; ++j {
                deck.append(Card(suit: i, suitString: suitStrings[i], value: j, valueString: valueStrings[j-1]))
            }
        }
    }
    
    func getCard() -> Card {
        //var randomCard = Int(rand()) % (deck.count - 1)
        var randomCard = Int(arc4random_uniform(UInt32(deck.count)))
        var cardOut = deck.removeAtIndex(randomCard)
        return cardOut
    }
    
    func newGame() {
        playerCash = 100
        shuffleDeck()
        newRound()
    }
    
    func newRound() {
        gameStatus = 1
        playerWon = false
        dealer = 0
        dealerCards = [Card]()
        player = 0
        playerCards = [Card]()
        //Draw 4 cards
        for var i = 0; i < 4; ++i {
            var drawnCard = getCard()
            var drawnCardValue = drawnCard.value
            if drawnCardValue > 10 { drawnCardValue = 10 }
            //Give first two cards to player
            if i < 2 {
                player += drawnCardValue
                playerCards.append(drawnCard)
                //In this version, Ace is only 1, not 1 or 11. Impossible for player to win immediately.
            }
            //Give last two cards to dealer
            else {
                dealer += drawnCardValue
                dealerCards.append(drawnCard)
            }
        }
        
        //Take player's bet
        playerCash--
        
    }
    
    func playerHit() {
        var drawnCard = getCard()
        var drawnCardValue = drawnCard.value
        if drawnCardValue > 10 { drawnCardValue = 10 }
        
        player += drawnCardValue
        playerCards.append(drawnCard)
        
        if player == 21 { playerWin() } //Simplified, does not consider if dealer has 21
        else if player > 21 { playerLose() }
    }
    
    func playerStay() {
        if dealer <= 16 {
            var drawnCard = getCard()
            var drawnCardValue = drawnCard.value
            if drawnCardValue > 10 { drawnCardValue = 10 }
            
            dealer += drawnCardValue
            dealerCards.append(drawnCard)
        }
        if dealer == 21 {
            playerLose()
        } else if dealer >= 21 {
            playerWin()
        } else if dealer > player {
            playerLose()
        } else if dealer < player {
            playerWin()
        }
        
    }
    
    func playerLose(){
        gameStatus = 2
        playerWon = false
        gamesPlayed++
        
        if(playerCash == 0) {
            gameStatus = 3
        }
        if(gamesPlayed == 5) {
            shuffleDeck()
            gamesPlayed = 0
        }
    }
    
    func playerWin() {
        gameStatus = 2
        playerWon = true
        gamesPlayed++
        playerCash+=2
        
        if(gamesPlayed == 5) {
            shuffleDeck()
            gamesPlayed = 0
        }
    }
}