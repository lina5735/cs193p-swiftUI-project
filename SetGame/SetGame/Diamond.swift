//
//  CardContent.swift
//  SetGame
//
//  Created by lina on 3/11/22.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y:rect.midY)
//        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x, y: center.y-rect.height/2)
                
        var p = Path()
        p.move(to: start)
        p.addLine(to: CGPoint(x: center.x-rect.width/2, y: center.y))
        p.addLine(to: CGPoint(x: center.x, y: center.y+rect.height/2))
        p.addLine(to: CGPoint(x: center.x+rect.width/2, y: center.y))
        p.addLine(to: start)
        
        return p
    }
}
