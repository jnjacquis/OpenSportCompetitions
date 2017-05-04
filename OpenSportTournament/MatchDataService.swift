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
    static let instance: MatchsDataService = MatchsDataService()
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    
    private var _matches: [MatchMO]
    public var matches: [MatchMO] {
        get {
            return self._matches
        }
    }
    
    private init() {
        self._matches = [MatchMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Match", in: managedContext)!
        
        self.fetchAll()
    }
    
    private func fetchAll() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Match")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            var matches = results as! [MatchMO]
            
            self._matches = matches
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomeMatches() -> [MatchMO]
    {
        var matches = Set<MatchMO>()
        
        let match = MatchMO(entity: self.entity, insertInto: self.managedContext)
        matches.update(with: match)
        
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
