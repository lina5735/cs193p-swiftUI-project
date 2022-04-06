//
//  SetGameVModel.swift
//  SetGame
//
//  Created by lina on 3/6/22.
//

import Foundation

class SetGame: ObservableObject{
    typealias Card = Match3Game<SetContent>.Card
    
    @Published private var model: Match3Game<SetContent> = SetGame.createSetGame()
    
    static var createAllCards: Array<SetContent>{
        var contentList: Array<SetContent> = []
        for s in SetContent.cardShape.allCases{
            for c in SetContent.cardColor.allCases{
                for n in SetContent.cardNum.allCases{
                    for sd in SetContent.cardShading.allCases{
                        contentList.append(SetContent(shape: s, color: c, number: n, shading: sd))
                    }
                }
            }
        }
        return contentList
    }
    
    static func createSetGame() -> Match3Game<SetContent>{
        return Match3Game<SetContent>(numberOfPairsOfCards: createAllCards.count){ pairIndex in
            createAllCards[pairIndex]
        }
    }
    
    
    struct SetContent : CustomStringConvertible,Matchable{
        let shape: cardShape
        let color: cardColor
        let number: cardNum
        let shading: cardShading
                
        var description: String{
            return "\(shape.rawValue),\(color.rawValue),\(number.rawValue),\(shading.rawValue)"
        }
        
        private func SameOrDiff(a:String, b:String, c:String)->Bool{
            return ((a==b) && (b==c)) || (!(a==b) && !(b==c) && !(a==c))
        }
        
        func makeSet(item1: SetContent, item2: SetContent)->Bool{
            return SameOrDiff(a: self.shape.rawValue, b: item1.shape.rawValue, c: item2.shape.rawValue) && SameOrDiff(a: self.color.rawValue, b: item1.color.rawValue, c: item2.color.rawValue) &&
                SameOrDiff(a: self.number.rawValue, b: item1.number.rawValue, c: item2.number.rawValue) &&
                SameOrDiff(a: self.shading.rawValue, b: item1.shading.rawValue, c: item2.shading.rawValue)
        }
        
        enum cardShape: String, CaseIterable{
            case oval
            case rectangle
            case diamond
        }
        
        enum cardColor: String, CaseIterable{
            case brown
            case purple
            case yellow
        }
        
        enum cardNum: String, CaseIterable{
            case one
            case two
            case three
        }
        
        enum cardShading: String, CaseIterable{
            case solid
            case striped
            case outlined
        }
        
        
    }
    
    var cards: Array<Card>{
        model.cards
    }
    
    var cardsDeck: Array<Card>{
        model.cards.filter({!$0.isDisplayed && !$0.isMatched})
    }
    
    var cardsDiscard: Array<Card>{
        model.cards.filter({!$0.isDisplayed && $0.isMatched})
    }
    
    var cardsDisplay: Array<Card>{
        model.cards.filter({$0.isDisplayed})
//        model.desk.map{index in model.cards[index]}
    }
    
    var notMatched: Bool{
        return cardsDisplay.filter({$0.isSelected && !$0.isMatched}).count == 3
    }
    
    
//    var deckNoEmpty: Bool{
//        return model.getMoreCards() != nil
//    }
    
    // MARK: - Intend(s)
    
    
    func choose(_ card: Card){
        model.choose(card)
    }
    
    func deal3Cards(){
        model.deal3Cards()
    }
    
    func newGame(){
        model = SetGame.createSetGame()
    }
    
    
}
