//
//  MatchEngine.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 22/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class MatchEngine {
    
    public func nextMatch(competitors: [CompetitorMO]) -> (CompetitorMO, CompetitorMO)? {
        guard competitors.count >= 2 else {
            return nil
        }
        
        let people: NSMutableArray = NSMutableArray(array: competitors)
        let randomNumber1 = arc4random_uniform(UInt32(people.count))
        print("Random index for the 1st competitor: ", randomNumber1)
        
        var randomNumber2: UInt32? = nil
        
        repeat {
            randomNumber2 = arc4random_uniform(UInt32(people.count))
        } while randomNumber1 != randomNumber2
        print("Random index for the 2nd competitor: ", randomNumber2)
        
        return (competitors[Int(randomNumber1)], competitors[Int(randomNumber2!)])
    }
}
