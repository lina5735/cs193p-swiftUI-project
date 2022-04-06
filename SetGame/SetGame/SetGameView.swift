//
//  ContentView.swift
//  SetGame
//
//  Created by lina on 3/6/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    @Namespace private var cardNamespace
    
    var body: some View {
        VStack{
            showMatchStatus
            gameBody
            
            HStack{
                deckBody
                Spacer()
                discardBody
            }
            .padding()
            
            restartBtn

            
        }
        .padding()
    }

    
    var gameBody: some View{
        AspectVGrid(items: game.cardsDisplay, aspectRatio: CardConstants.aspectRatio, content: { card in
            CardView(card, NotMatched: game.notMatched)
                .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                //animation can only happened on view that already on the screen
                .animation(.easeInOut(duration: 1),value: card.isMatched)
                .scaleEffect( (game.notMatched && card.isSelected) ? 0.8 : 1 )
                .animation(.easeInOut.repeatCount(1, autoreverses: true),value: (game.notMatched && card.isSelected))
                .matchedGeometryEffect(id: card.id, in: cardNamespace)
                .padding(8)
                .onTapGesture {
                    withAnimation{
                        game.choose(card)
                    }
                    
                }
           })
    }
    
    var deckBody: some View {
        VStack{
            cardStack(cards: game.cardsDeck, faceDown: true)
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
                .onTapGesture {
                    withAnimation{
                        game.deal3Cards()
                    }
                }
            Text("Deal 3")
        }
       
    }
    
    
    var discardBody: some View {
        VStack{
            cardStack(cards: game.cardsDiscard)
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            Text("Matched")
        }
        
    }
    
    @ViewBuilder
    private func cardStack(cards: Array<SetGame.Card>, faceDown: Bool = false) -> some View{
        if cards.count == 0{
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20)
                shape.fill().foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                Text("Empty").foregroundColor(.gray)
            }
        } else {
            ZStack{
                if faceDown{
                    // Deck: show list top - to be added
                    ForEach(cards){ card in
                        CardView(card)
                            .matchedGeometryEffect(id: card.id, in: cardNamespace)
                            .zIndex(zIndex2(of: card))
                    }
                    let shape = RoundedRectangle(cornerRadius: 20)
                    shape.fill().foregroundColor(Color(UIColor.lightGray))
                    Text("?").font(.largeTitle).foregroundColor(.gray)
                } else {
                    // Discard: show list tail - just added
                    ForEach(cards){ card in
                        CardView(card)
                            .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    }
                }
            }
        }
        
    }
    
    private func zIndex2(of card: SetGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var restartBtn: some View{
        Button(action: {
            game.newGame()
        }, label: {
            Text("New Game")
        })
        .padding(.horizontal)
        .font(.title)
    }

    
    
    private var showMatchStatus: some View{
        // Show whether cards are match on the top
        ZStack{
            RoundedRectangle(cornerRadius:10).fill().foregroundColor(.white).frame(height:50)
            if game.cardsDisplay.contains(where:{$0.isMatched}) {
                Text("Set Matched!")
                    .foregroundColor(.green)
            } else if game.notMatched {
                Text("Not Matched")
                    .foregroundColor(.red)
            }else {
                Text("Building Set...")
                    .foregroundColor(.black)
            }
            
        }
        .font(.largeTitle)
        .foregroundColor(.white)
    }
    
//    @ViewBuilder
//    private func show3Button()-> some View {
//        // disable button when deck is empty
//        if game.deckNoEmpty{
//            Button(action: {
//                game.deal3Cards()
//            }, label: {
//                Text("Deal 3 More Cards")
//            })
//            .padding(.vertical)
//        } else {
//            Text("Deal 3 More Cards")
//                .padding(.vertical)
//                .foregroundColor(Color(UIColor.lightGray))
//        }
//    }
    
    private struct CardConstants{
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}







struct CardView: View{
    // only pass in the minimum object, the single card
    // read-only card, use let instead of var
    let card:SetGame.Card
    let NotMatched: Bool
    
    
    init(_ card: SetGame.Card, NotMatched: Bool = false){
        self.card = card
        self.NotMatched = NotMatched
    }
    

    
    var body: some View{
        GeometryReader{ geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.fill().foregroundColor(DrawingBackColor).opacity(0.1)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(Color(UIColor.lightGray))
                contentShape()
                    .foregroundColor(DrawingShapeColor)
                // Text(card.content.description).multilineTextAlignment(.center)
            }
            .foregroundColor(.gray)
        }
    }
    
    
    
    @ViewBuilder
    private func contentShape()->some View{
        GeometryReader{ geometry in
            switch card.content.number{
                case .one:
                    VStack{
                        addShape()
                    }
                    .padding(.horizontal,geometry.size.width*1/6)
                    .padding(.vertical,geometry.size.height*7/18)
                case .two:
                    VStack{
                        addShape()
                        addShape()
                    }
                    .padding(.horizontal,geometry.size.width*1/6)
                    .padding(.vertical,geometry.size.height*5/18)
                case .three:
                    VStack{
                        addShape()
                        addShape()
                        addShape()
                    }
                    .padding(.horizontal,geometry.size.width*1/6)
                    .padding(.vertical,geometry.size.height*3/18)
            } //switch
        }
    }
    
    
    @ViewBuilder
    private func addShape()->some View{
        switch card.content.shape{
            case .oval:
                switch card.content.shading{
                    case .solid: Ellipse()
                    case .outlined: Ellipse().stroke(lineWidth:3)
                    case .striped: ZStack{
                        Ellipse().opacity(0.3)
                        Ellipse().stroke(lineWidth:2)
                    }
                }
            case .rectangle:
                switch card.content.shading{
                    case .solid: Rectangle()
                    case .outlined: Rectangle().stroke(lineWidth:3)
                    case .striped: ZStack{
                        Rectangle().opacity(0.3)
                        Rectangle().stroke(lineWidth:2)
                    }
                }
            case .diamond:
                switch card.content.shading{
                    case .solid: Diamond()
                    case .outlined: Diamond().stroke(lineWidth:3)
                    case .striped: ZStack{
                        Diamond().opacity(0.3)
                        Diamond().stroke(lineWidth:2)
                    }
                }
        }
    }
    
    private var DrawingShapeColor: Color{
        switch card.content.color{
            case .yellow: return Color.yellow
            case .purple: return Color.purple
            case .brown: return Color.brown
        }
    }
    
    
    private var DrawingBackColor:Color{
        if card.isMatched {
            return Color.green
        }else if card.isSelected && NotMatched{
            return Color.red
        }else if card.isSelected {
            return Color.blue
        }
        return Color.white
    }
    
    
    private func font(in size: CGSize) -> Font{
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.65
    }
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return SetGameView(game: game)
//            .preferredColorScheme(.dark)
    }
}
