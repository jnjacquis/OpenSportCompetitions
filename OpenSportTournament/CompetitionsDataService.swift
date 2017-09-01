//
//  CompetitionsDataService.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 24/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class CompetitionsDataService {
    static let instance: CompetitionsDataService = CompetitionsDataService()
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    
    private var _competitions: [CompetitionMO]
    public var competitions: [CompetitionMO] {
        get {
            return self._competitions
        }
    }
    
    private init() {
        self._competitions = [CompetitionMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Competition", in: managedContext)!
        
        self.fetchAll()
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
        let fetchRequest = CompetitionMO.getFetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            var competitions = results

//            if competitions.count == 0 {
//                competitions = mockSomeCompetitions()
//                print("Mock competitions generated with success")
//                
//                for competition in competitions {
//                    self.save(competition: competition)
//                }
//                print("Mock competitions saved with success")
//            }
            
            for competition in competitions {
                if let competitors = competition.competitors {
                    print("Competition with \(competitors.count) competitors")
                } else {
                    print("Competition with no competitor")
                }
            }
            
            
            self._competitions = competitions
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomeCompetitions() -> [CompetitionMO]
    {
        var compets = Set<CompetitionMO>()
        
        let playerEntity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!

        var compet =  CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Summer children 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compet.competitorType = 0
        compet.competitors = NSMutableSet()
        if let player = PlayersDataService.instance.find(name: "Clément J.") {
            player.competition = compet
            compet.competitors?.adding(player)        }
        if let player = PlayersDataService.instance.find(name: "Matéo V.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        if let player = PlayersDataService.instance.find(name: "Mayra V.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        if let player = PlayersDataService.instance.find(name: "Nicolas J.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        compets.update(with: compet)
        
        compet = CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Woman Open 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compet.competitorType = 0
        compet.competitors = NSMutableSet()
        if let player = PlayersDataService.instance.find(name: "Christelle J.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        if let player = PlayersDataService.instance.find(name: "Nell V.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        if let player = PlayersDataService.instance.find(name: "Mayra V.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        compets.update(with: compet)
        
        compet = CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Senior 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compet.competitorType = 0
        compet.competitors = NSMutableSet()
        if let player = PlayersDataService.instance.find(name: "Jean-Charles V.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        if let player = PlayersDataService.instance.find(name: "Jean-Noel J.") {
            player.competition = compet
            compet.competitors?.adding(player)
        }
        compets.update(with: compet)
        
        return Array(compets)
    }
    
    public func save(competition: CompetitionMO) {
        print("Competition item is about to be saved from the current context")
        
        if let context = competition.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
                
                if !self._competitions.contains(competition) {
                    self._competitions.append(competition)
                    print("->Add successfull")
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    public func delete(competition: CompetitionMO) {
        print("Competition item is about to be deleted from the current context")
        
        if let context = competition.managedObjectContext {
            context.delete(competition)
            print("->Delete successfull")
            
            if self._competitions.contains(competition) {
                if let index = self._competitions.index(of: competition) {
                    self._competitions.remove(at: index)
                    print("->Remove successfull")
                }
            }
        }
    }
}
