//
//  SetGame.swift
//  SetGame
//
//  Created by lina on 3/6/22.
//

import Foundation

struct Match3Game<CardContent> where CardContent: Matchable {
    private(set) var cards: Array<Card>
        
    private var IndexOfSelectedCards: Array<Int>!{
        get{
            let indexList = cards.indices.filter({cards[$0].isSelected})
            if indexList.count == 0{
                return nil
            } else {
                return indexList
            }
        }
    }
    
    private func allMatch(indexList: Array<Int>)->Bool{
        // Check if all cards in List is Matched card
        return indexList.filter{index in cards[index].isMatched}.count == 3
    }
    
    func getMoreCards()->Int!{
        // find cards on deck
        return cards.firstIndex(where: {!$0.isMatched && !$0.isDisplayed})
    }
    
    
    
    mutating func deal3Cards(){
        // add 3 cards
        for _ in 0..<3{
            if let newID = getMoreCards(){
                cards[newID].isDisplayed.toggle()
            }
        }
        //  if there's match, replace it
        if let crntSelected = IndexOfSelectedCards{
            if allMatch(indexList: crntSelected){
                crntSelected.forEach{index in cards[index].isSelected.toggle()}
                crntSelected.forEach{index in cards[index].isDisplayed.toggle()}
            }
        }
        
    }
    
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}){
            if let crntSelected = IndexOfSelectedCards {
                // 1,2,or 3 cards selected
                if crntSelected.contains(chosenIndex){
                    // Select the same selected card
                    // if not 3 matched Cards, deSelect the same card
                    if !(crntSelected.count == 3 && allMatch(indexList: crntSelected)) {
                        cards[chosenIndex].isSelected.toggle() //old card deselect
                    }
                } else{
                    // Select new card
                    cards[chosenIndex].isSelected.toggle() //new card selected
                    if crntSelected.count == 2{
                        // Check if create a new match, if match, isMatched +3
                        if cards[chosenIndex].makeSet(card1: cards[crntSelected[0]],
                                                      card2: cards[crntSelected[1]]){
                            cards[chosenIndex].isMatched.toggle()
                            crntSelected.forEach{index in cards[index].isMatched.toggle()}
                        }
                    } else if crntSelected.count == 3{
                        // deSelect all 3 cards
                        crntSelected.forEach{index in cards[index].isSelected.toggle()}
                        // If match, un-display 3 matched card, move 3 new unmatch card to display
                        if allMatch(indexList: crntSelected){
                            crntSelected.forEach{index in cards[index].isDisplayed.toggle()}
                        }
                    }
                }
            } else {
                // 0 Selected
                cards[chosenIndex].isSelected.toggle()
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = []
//        desk = []
        for pairIndex in 0..<numberOfPairsOfCards{
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id:pairIndex))
        }
//        cards = cards.shuffled()
        for i in 0..<12{
            cards[i].isDisplayed = true
        }
//        print(cards)
                    
        
    }
    
    
    
    struct Card: Identifiable{
        var isDisplayed = false // whether display on desk
        var isSelected = false
        var isMatched = false // if false -> potential to be on desk
        
        func makeSet(card1: Card, card2: Card)->Bool{
            return content.makeSet(item1:card1.content, item2:card2.content)
        }
        
        let content: CardContent
        let id: Int
        
    
    }
}

protocol Matchable{
    func makeSet(item1:Self, item2:Self)->Bool //Can compare with two other elements to check whether make a set
}

