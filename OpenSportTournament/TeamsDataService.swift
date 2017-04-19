//
//  TeamsDataService.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 28/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

//
//  TeamsDataService.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 27/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class TeamsDataService {
    static let instance: TeamsDataService = TeamsDataService()
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    
    private var _teams: [TeamMO]
    public var teams: [TeamMO] {
        get {
            return self._teams
        }
    }
    
    private init() {
        self._teams = [TeamMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Team", in: managedContext)!
        
        self.fetchAll()
    }
    
    public func fetchAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            var teams = results as! [TeamMO]
            
//            if teams.count == 0 {
//                teams = mockSomeTeams()
//                print("Mock teams generated with success")
//                
//                for team in teams {
//                    self.save(team: team)
//                }
//                print("Mock teams saved with success")
//            }
            
            self._teams = teams
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomeTeams() -> [TeamMO]
    {
        var teams = Set<TeamMO>()
        
        let playerEntity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!
        
        var team = TeamMO(entity: self.entity, insertInto: self.managedContext)
        team.name = "Green team"
        var member1 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member1.id = 1
        member1.name = "Clément J."
        var member2 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member2.id = 2
        member2.name = "Jean-Noel J."
        team.members = [member1, member2]
        teams.update(with: team)

        team = TeamMO(entity: self.entity, insertInto: self.managedContext)
        team.name = "Blue team"
        member1 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member1.id = 3
        member1.name = "Christelle J."
        member2 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member2.id = 4
        member2.name = "Nicolas J."
        team.members = [member1, member2]
        teams.update(with: team)
        
        team = TeamMO(entity: self.entity, insertInto: self.managedContext)
        team.name = "Red team"
        member1 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member1.id = 5
        member1.name = "Jean-Charles V."
        member2 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member2.id = 6
        member2.name = "Mayra V."
        team.members = [member1, member2]
        teams.update(with: team)
        
        team = TeamMO(entity: self.entity, insertInto: self.managedContext)
        team.name = "Black team"
        member1 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member1.id = 7
        member1.name = "Matéo V."
        member2 = PlayerMO(entity: playerEntity, insertInto: self.managedContext)
        member2.id = 8
        member2.name = "Nell V."
        team.members = [member1, member2]
        teams.update(with: team)
        
        return Array(teams)
    }
    
    public func save(team: TeamMO) {
        print("Team item is about to be saved from the current context")
        
        if let context = team.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
                
                if !self._teams.contains(team) {
                    self._teams.append(team)
                    print("->Add successfull")
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    public func delete(team: TeamMO) {
        print("Team item is about to be deleted from the current context")
        
        if let context = team.managedObjectContext {
            context.delete(team)
            print("->Delete successfull")
            
            if self._teams.contains(team) {
                if let index = self._teams.index(of: team) {
                    self._teams.remove(at: index)
                    print("->Remove successfull")
                }
            }
        }
    }
}


