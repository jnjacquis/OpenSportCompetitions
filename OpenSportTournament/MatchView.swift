//
//  MatchView.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 23/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit

class MatchView: UIView {

    private var _match: MatchMO?
    var match: MatchMO {
        get {
            return self._match!
        }
        set {
            self._match = newValue
        }
    }
    
    var _foregroundColor: UIColor = UIColor.white
    var foregroundColor: UIColor {
        get {
            return _foregroundColor
        }
        set {
            self._foregroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(match: MatchMO, backgroundColor: UIColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        
        self.match = match
        self.backgroundColor = backgroundColor
    }
    
    convenience init(match: MatchMO, frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        
        self.match = match
        self.backgroundColor = backgroundColor
    }
    
    public override func draw(_ rect: CGRect) {
        // Compute some constants depending on the size to draw
        let width1: Int = Int(rect.width * 0.6)
        //let width2: Int = Int(rect.width * 0.4)
        let height1: Int = Int(rect.height * 0.25)
        let height2: Int = Int(rect.height * 0.5)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(2.0)
        
        context?.move(to: CGPoint(x: 0, y: height1))
        context?.addLine(to: CGPoint(x: width1, y: height1))
        context?.addLine(to: CGPoint(x: width1, y: height2))
        context?.addLine(to: CGPoint(x: Int(rect.width), y: height2))
        context?.move(to: CGPoint(x: width1, y: height2))
        context?.addLine(to: CGPoint(x: width1, y: height1 + height2))
        context?.addLine(to: CGPoint(x: 0, y: height1 + height2))
        
        context?.setStrokeColor(self.foregroundColor.cgColor)
        context?.strokePath()
        
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSParagraphStyleAttributeName: NSParagraphStyle.default,
            NSForegroundColorAttributeName: self.foregroundColor]
        
        let match = self.match
        let competitor = match.competitor1
        let name = competitor?.name
        self._match?.competitor1?.name?.draw(at: CGPoint(x: 12, y: height1 - 16), withAttributes: attrs)
        self._match?.competitor2?.name?.draw(at: CGPoint(x: 12, y: height1 + height2 - 16), withAttributes: attrs)
        
        if self._match?.competitor1 != nil, let score1 = self._match?.scoreCompetitor1 {
            var s = String(score1)
            var ns = NSString(string: s)
            s.draw(at: CGPoint(x: 12, y: height1 + 2), withAttributes: attrs)
        }
        if self._match?.competitor2 != nil, let score2 = self._match?.scoreCompetitor2 {
            var s = String(score2)
            var ns = s as NSString
            s.draw(at: CGPoint(x: 12, y: height1 + height2 + 2), withAttributes: attrs)
        }
        
    }
}
