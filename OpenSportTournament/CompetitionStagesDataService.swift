//
//  CompetitionStages.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 04/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class CompetitionStagesDataService {
    static let instance: CompetitionStagesDataService = CompetitionStagesDataService()
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    
    private var _stages: [CompetitionStageMO]
    public var stages: [CompetitionStageMO] {
        get {
            return self._stages
        }
    }
    
    private init() {
        self._stages = [CompetitionStageMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "CompetitionStage", in: managedContext)!
        
        self.fetchAll()
    }
    
    public func firstActiveStage() -> CompetitionStageMO? {
        let result = CompetitionStageMO(entity: CompetitionStagesDataService.instance.entity, insertInto: CompetitionStagesDataService.instance.managedContext)
        result.active = true
        result.type = 0
        return result
    }
    
    public func previousActiveStage(_ stage: CompetitionStageMO) -> CompetitionStageMO? {
        let result = CompetitionStageMO(entity: CompetitionStagesDataService.instance.entity, insertInto: CompetitionStagesDataService.instance.managedContext)
        result.active = true
        result.type = 0
        return result
    }
    
    public func nextActiveStage(_ stage: CompetitionStageMO) -> CompetitionStageMO? {
        let result = CompetitionStageMO(entity: CompetitionStagesDataService.instance.entity, insertInto: CompetitionStagesDataService.instance.managedContext)
        result.active = true
        result.type = 0
        return result
    }
    
    public func queryActiveStages() -> [CompetitionStageMO] {
        let fetchRequest = CompetitionStageMO.getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "active == YES")
        
        var result: [CompetitionStageMO] = [CompetitionStageMO]()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            result = results as! [CompetitionStageMO]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    public func fetchAll() {
        //        let fetchCompetitorsRequest: NSFetchRequest<CompetitorMO> = CompetitorMO.fetchRequest()
        //
        //        do {
        //            let results = try managedContext.fetch(fetchCompetitorsRequest)
        //            let competitors = results as! [CompetitorMO]
        //
        //            for competitor in competitors {
        //                print("Competitor named \(competitor.name ?? "JJS")")
        //            }
        //
        //        } catch let error as NSError {
        //            print("Could not fetch \(error), \(error.userInfo)")
        //        }
        
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Competition")
        let fetchRequest = CompetitionStageMO.getFetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "active == YES")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            var stages = results as! [CompetitionStageMO]
            
            //stages = mockSomeCompetitionStages()
            
            if stages.count == 0 {
                stages = mockSomeCompetitionStages()
                print("Mock competition stages generated with success")
                
//                for competition in competitions {
//                    self.save(competition: competition)
//                }
//                print("Mock competitions saved with success")
            } else {
                for stage in stages {
                    if let matchesCount = stage.matches?.count {
                        print("Stage with \(matchesCount) matches")
                    } else {
                        print("Stage with no match")
                    }
                }
            }
            
            self._stages = stages
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomeCompetitionStages() -> [CompetitionStageMO]
    {
        var stages = Set<CompetitionStageMO>()
        
        let competitionEntity = NSEntityDescription.entity(forEntityName: "Competition", in: managedContext)!
        let competitorEntity = NSEntityDescription.entity(forEntityName: "Competitor", in: managedContext)!
        let matchEntity = NSEntityDescription.entity(forEntityName: "Match", in: managedContext)!
        
        var compet = CompetitionMO(entity: competitionEntity, insertInto: self.managedContext)
        compet.title = "TCPT Summer children 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compet.competitorType = 0
        compet.competitors = NSMutableSet()
        
        var playerClementJ: CompetitorMO?
        if let player = PlayersDataService.instance.find(name: "Clément J.") {
            player.competition = compet
            compet.competitors?.adding(player)
            playerClementJ = player
        }
        else {
            playerClementJ = CompetitorMO(entity: competitorEntity, insertInto: self.managedContext)
            playerClementJ?.name = "Clément J."
        }
        var playerMateoV: CompetitorMO?
        if let player = PlayersDataService.instance.find(name: "Matéo V.") {
            player.competition = compet
            compet.competitors?.adding(player)
            playerMateoV = player
        }
        else {
            playerMateoV = CompetitorMO(entity: competitorEntity, insertInto: self.managedContext)
            playerMateoV?.name = "Matéo V."
        }
        var playerMayraV: CompetitorMO?
        if let player = PlayersDataService.instance.find(name: "Mayra V.") {
            player.competition = compet
            compet.competitors?.adding(player)
            playerMayraV = player
        }
        else {
            playerMayraV = CompetitorMO(entity: competitorEntity, insertInto: self.managedContext)
            playerMayraV?.name = "Mayra V."
        }
        var playerNicolasJ: CompetitorMO?
        if let player = PlayersDataService.instance.find(name: "Nicolas J.") {
            player.competition = compet
            compet.competitors?.adding(player)
            playerNicolasJ = player
        }
        else {
            playerNicolasJ = CompetitorMO(entity: competitorEntity, insertInto: self.managedContext)
            playerNicolasJ?.name = "Nicolas J."
        }
        
        let stage = CompetitionStageMO(entity: self.entity, insertInto: self.managedContext)
        stage.id = 1
        stage.active = true
        stage.competition = compet
        //stage.competitors =
        stage.matches = NSSet()
        
        let match1 = MatchMO(entity: matchEntity, insertInto: self.managedContext)
        match1.id = 101
        match1.competitor1 = playerClementJ
        match1.competitor2 = playerMateoV
        stage.addToMatches(match1)
        //stage.matches?.adding(match1)
      
        let match2 = MatchMO(entity: matchEntity, insertInto: self.managedContext)
        match2.id = 102
        match2.competitor1 = playerClementJ
        match2.competitor2 = playerMateoV
        stage.addToMatches(match2)
        //stage.matches?.adding(match2)
    
        stages.update(with: stage)
        
        return Array(stages)
    }
    
    public func save(stage: CompetitionStageMO) {
        print("Stage of competition item is about to be saved from the current context")
        
        if let context = stage.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
                
                if !self._stages.contains(stage) {
                    self._stages.append(stage)
                    print("->Add successfull")
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
//    public func delete(competition: CompetitionMO) {
//        print("Competition item is about to be deleted from the current context")
//        
//        if let context = competition.managedObjectContext {
//            context.delete(competition)
//            print("->Delete successfull")
//            
//            if self._competitions.contains(competition) {
//                if let index = self._competitions.index(of: competition) {
//                    self._competitions.remove(at: index)
//                    print("->Remove successfull")
//                }
//            }
//        }
//    }
}
