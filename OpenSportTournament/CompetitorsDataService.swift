//
//  CompetitorsDataService.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 08/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import CoreData

class CompetitorsDataService {
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    var competitors: [CompetitorMO]
    
    init() {
        self.competitions = [CompetitionMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Competition", in: managedContext)!
    }
    
    public func loadAll() -> [CompetitionMO] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Competition")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            self.competitions = results as! [CompetitionMO]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if self.competitions.count == 0 {
            self.competitions = mockSomeCompetitions()
        }
        
        return self.competitions
    }
    
    private func mockSomeCompetitions() -> [CompetitionMO]
    {
        var compets = Set<CompetitionMO>()
        
        var compet =  CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Summer children 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compets.update(with: compet)
        
        compet = CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Open 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compets.update(with: compet)
        
        compet = CompetitionMO(entity: self.entity, insertInto: self.managedContext)
        compet.title = "TCPT Senior 2017"
        compet.sport = "Tennis"
        compet.startDate = nil
        compet.endDate = nil
        compets.update(with: compet)
        
        return Array(compets)
    }
    
    public static func save(competition: CompetitionMO) {
        print("Competition item is about to be saved from the current context")
        
        if let context = competition.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    public static func delete(competition: CompetitionMO) {
        print("Competition item is about to be deleted from the current context")
        
        if let context = competition.managedObjectContext {
            context.delete(competition)
            print("->Delete successfull")
        }
    }
}

