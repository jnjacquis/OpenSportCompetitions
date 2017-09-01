//
//  PoolGenerator.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 20/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation

class PoolGenerator {
    
    public static func computeMatches(_ stage: CompetitionStageMO) -> (Node<MatchMO>, Int)? {

        // Unwrap and guard all competitors of the current stage
        guard let stageCompetitors = stage.competitors else {
            return nil
        }
        
        
        var allStageCompetitors: Stack<CompetitorMO?> = Stack(array: stageCompetitors.allObjects as! [CompetitorMO])
        print("Competitors in stage: #\(allStageCompetitors.count)")
        
        // Compute the number of levels in the tree of matches for the stage depending on the number 
        let levelsCount = computeLevels(value: allStageCompetitors.count)
        print("\(levelsCount) levels of matches for \(stageCompetitors.count) competitors")
        
        var competitors: [CompetitorMO?] = stageCompetitors.allObjects as! [CompetitorMO?]
        
        // Update competitors with dummy (ie nil) competitors
        let max = powf(2.0, Float(levelsCount))
        let maxCompetitors = Int(max)
        insertNilCompetitors(competitors: &competitors, maxCompetitors: maxCompetitors)
        allStageCompetitors = Stack(array: competitors)
        
        let rootMatch: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        rootMatch.id = 0
        let tree: Node<MatchMO> = Node(value: rootMatch, level: 0)
        
        generateChildrenMatches(level: 1, maxLevel: levelsCount - 1, parent: tree, competitors: &allStageCompetitors)
        
        return (tree, levelsCount)
    }
    
    private static func insertNilCompetitors(competitors: inout [CompetitorMO?], maxCompetitors: Int) {
        if competitors.count >= maxCompetitors {
            return
        }
        
        let newNilCompetitorsCount = maxCompetitors - competitors.count
        print("#\(newNilCompetitorsCount) new competitors")
        
        for _ in 0...(newNilCompetitorsCount-1) {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(competitors.count)))
            competitors.insert(nil, at: randomIndex)
            print("Nil competitor inserted at index \(randomIndex)")
        }
    }
    
    private static func random(range: Range<UInt32>) -> UInt32 {
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    
    private static func generateChildrenMatches(level: Int, maxLevel: Int, parent: Node<MatchMO>, competitors: inout Stack<CompetitorMO?>) -> Void {
        
        // Create the first match
        let firstMatch: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        firstMatch.id = 1
        let firstChild = Node(value: firstMatch)
        //var firstChild: Node<MatchMO>? = nil
        
        if level == maxLevel {
            let competitor1: CompetitorMO? = competitors.pop()!
            let competitor2: CompetitorMO? = competitors.pop()!
            
//            
//            if competitor1 != nil && competitor2 != nil {
//                firstMatch.competitor1 = competitor1
//                firstMatch.competitor2 = competitor2
//                print(firstMatch)
//            }
//            else if competitor1 != nil {
//                parent.value.competitor1 = competitor1
//            }
//            else if competitor2 != nil {
//                parent.value.competitor1 = competitor2
//            }
//            
            if competitor1 != nil {
                firstMatch.competitor1 = competitor1
            }
            if competitor2 != nil {
                firstMatch.competitor2 = competitor2
            }
        }
        parent.add(child: firstChild)
        
        // Create the second match
        let secondMatch: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        secondMatch.id = 2
        let secondChild = Node(value: secondMatch)
        //var secondChild: Node<MatchMO>? = nil
        
        if level == maxLevel {
            let competitor3: CompetitorMO? = competitors.pop()!
            let competitor4: CompetitorMO? = competitors.pop()!
            //print("\(competitor3!.name) vs \(competitor4!.name)")
            
//            if competitor3 != nil && competitor4 != nil {
//                secondMatch.competitor1 = competitor3
//                secondMatch.competitor2 = competitor4
//                print(secondMatch)
//            }
//            else if competitor3 != nil {
//                parent.value.competitor1 = competitor3
//            }
//            else if competitor4 != nil {
//                parent.value.competitor1 = competitor4
//            }
            
            if competitor3 != nil {
                secondMatch.competitor1 = competitor3
            }
            if competitor4 != nil {
                secondMatch.competitor2 = competitor4
            }
        }
        parent.add(child: secondChild)
        
//        if level == maxLevel {
//            secondMatch.competitor1 = competitors.pop()
//            secondMatch.competitor2 = competitors.pop()
//            print(secondMatch)
//        }
//        parent.add(child: secondChild)
//        let childrenMatches = NSMutableSet()
//        childrenMatches.add(firstMatch)
//        childrenMatches.add(secondMatch)
//        parent.children = childrenMatches
        
        if level < maxLevel {
            let nextLevel = level + 1
            generateChildrenMatches(level: nextLevel, maxLevel: maxLevel, parent: firstChild, competitors: &competitors)
            generateChildrenMatches(level: nextLevel, maxLevel: maxLevel, parent: secondChild, competitors: &competitors)
        }
        
        //return (firstMatch, secondMatch)
    }
    
    public static func elements(at level: Int, root: Node<MatchMO>) -> [MatchMO] {
        if level == 0 {
            return [root.value]
        }
        else if (level == 1) || (level == root.level! + 1) {
            let childrenNodes = root.children
            let allChildrenMatches = NSMutableSet()
            for childNode in childrenNodes {
                allChildrenMatches.add(childNode.value)
            }
            return allChildrenMatches.allObjects as! [MatchMO]
        }
        else {
            let childrenNodes = root.children
            let allChildrenMatches = NSMutableSet()
            for childNode in childrenNodes {
                let childrenOfChild = elements(at: level, root: childNode)
                allChildrenMatches.addObjects(from: childrenOfChild)
            }
            return allChildrenMatches.allObjects as! [MatchMO]
        }
    }
    

    private static func computeLevels(value: Int) -> Int {
        var levels: Int = 1
        var numberOfCompetitors = 2 // Root level of the tree, i.e. the final, has 2 competitors
        
        while (value > numberOfCompetitors) {
            levels += 1 // Add one level to the tree
            numberOfCompetitors *= 2
        }
        
        return levels
    }
}
