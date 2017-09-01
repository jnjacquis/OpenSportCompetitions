//
//  MatchDataService.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class MatchsDataService {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    static let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Match", in: managedContext)!
    
    static let instance: MatchsDataService = MatchsDataService()

    private var _matches: [MatchMO]
    public var matches: [MatchMO] {
        get {
            return self._matches
        }
    }
    
    private init() {
        self._matches = [MatchMO]()
        
        self.fetchAll()
    }
    
    private func fetchAll() {
        
        let fetchRequest = MatchMO.getFetchRequest()
        
        do {
            let results = try MatchsDataService.managedContext.fetch(fetchRequest)
            var matches = results as! [MatchMO]
            
            if matches.count == 0 {
                matches = mockSomeMatches()
                print("Mock players generated with success")
            //
            //  for player in players {
            //     self.save(player: player)
            //  }
            //  print("Mock players saved with success")
            }
            
            self._matches = matches
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomeMatches() -> [MatchMO]
    {
        let compet = CompetitionMO(entity: CompetitionsDataService.instance.entity, insertInto: CompetitionsDataService.instance.managedContext)
        compet.title = "Tournoi des familles"
        compet.id = 100

        let competStageDescription = NSEntityDescription.entity(forEntityName: "CompetitionStage", in: MatchsDataService.managedContext)!
        let competStage1 = CompetitionStageMO(entity: competStageDescription, insertInto: MatchsDataService.managedContext)
        competStage1.id = 12
        competStage1.active = true
        competStage1.type = 0
        competStage1.competition = compet
        
        var matches = Set<MatchMO>()
        
        let match1 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match1.id = 101
        match1.stage = competStage1
        matches.update(with: match1)
        
        let match2 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match2.id = 102
        match2.stage = competStage1
        matches.update(with: match2)
        
        let match3 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match3.id = 103
        match3.stage = competStage1
        matches.update(with: match3)
        
        let match4 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match4.id = 104
        match4.stage = competStage1
        matches.update(with: match4)
        
        let match5 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match5.id = 105
        match5.stage = competStage1
        matches.update(with: match5)
        
        let match6 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match6.id = 106
        match6.stage = competStage1
        matches.update(with: match6)
        
        let match7 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match7.id = 107
        match7.stage = competStage1
        matches.update(with: match7)
        
        let match8 = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
        match8.id = 108
        match8.stage = competStage1
        matches.update(with: match8)
        
        
        return Array(matches)
    }
    
    public func save(match: MatchMO) {
        print("Match item is about to be saved from the current context")
        
        if let context = match.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
                
                if !self._matches.contains(match) {
                    self._matches.append(match)
                    print("->Add successfull")
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    public func delete(match: MatchMO) {
        print("Match item is about to be deleted from the current context")
        
        if let context = match.managedObjectContext {
            context.delete(match)
            print("->Delete successfull")
            
            if self._matches.contains(match) {
                if let index = self._matches.index(of: match) {
                    self._matches.remove(at: index)
                    print("->Remove successfull")
                }
            }
        }
    }
    
    public func find(id: Int16) -> MatchMO? {
        for match in self._matches {
            if match.id == id {
                return match
            }
        }
        
        return nil;
    }
}
