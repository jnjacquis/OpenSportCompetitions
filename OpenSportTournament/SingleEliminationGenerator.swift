//
//  SingleEliminationGenerator.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 11/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData

class SingleEliminationGenerator: MatchesGenerator {
    
    public static func computeMatches(_ stage: CompetitionStageMO) -> [MatchMO] {
        var matches: [MatchMO] = [MatchMO]()
        
        // Unwrap and guard all competitors of the current stage
        guard let stageCompetitors = stage.competitors else {
            return matches
        }
        
        // Create a new mutable set with competitors to be able to remove them 2 by 2 as after new match is generated
        var competitors: NSMutableSet = NSMutableSet()
        competitors.addObjects(from: stageCompetitors.allObjects)
        
        repeat {
            // Get the next 2 competitors
            if let nextOnes = nextMatch(competitors: competitors.allObjects as! [CompetitorMO]) {
                // Create new match with these competitors
                var match: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
                //match.stageId = stage
                match.id = 100
                match.competitor1 = nextOnes.0
                match.competitor2 = nextOnes.1
                
                // Remove the 2 competitors from the list
                competitors.remove(nextOnes.0)
                competitors.remove(nextOnes.1)
                
                // Add match to the result array
                matches.append(match)
            }
            
        } while (competitors.count >= 2)
        
        return matches;
    }
    
    private static func nextMatch(competitors: [CompetitorMO]) -> (CompetitorMO, CompetitorMO)? {
        guard competitors.count >= 2 else {
            return nil
        }
        
        let people: NSMutableArray = NSMutableArray(array: competitors)
        let randomNumber1 = arc4random_uniform(UInt32(people.count))
        let competitor1  = competitors[Int(randomNumber1)]
        print("Random competitor 1: " + competitor1.name!)
        
        var competitor2 = competitor1
        
        repeat {
            let randomNumber2 = arc4random_uniform(UInt32(people.count))
            competitor2 = competitors[Int(randomNumber2)]
            print("Random competitor 2: " + competitor2.name!)
        } while competitor1 == competitor2
        
        
        return (competitor1, competitor2)
    }
}
