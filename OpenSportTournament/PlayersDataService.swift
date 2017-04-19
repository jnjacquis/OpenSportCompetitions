//
//  PlayersDataService.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 27/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class PlayersDataService {
    static let instance: PlayersDataService = PlayersDataService()
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    
    private var _players: [PlayerMO]
    public var players: [PlayerMO] {
        get {
            return self._players
        }
    }
    
    private init() {
        self._players = [PlayerMO]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!
        
        self.fetchAll()
    }
    
    private func fetchAll() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            var players = results as! [PlayerMO]
            
//            if players.count == 0 {
//                players = mockSomePlayers()
//                print("Mock players generated with success")
//                
//                for player in players {
//                    self.save(player: player)
//                }
//                print("Mock players saved with success")
//            }
            
            self._players = players
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func mockSomePlayers() -> [PlayerMO]
    {
        let calendar = Calendar.current
        
        var players = Set<PlayerMO>()
        
        var player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 1
        player.name = "Nicolas J."
        player.gender = "Man"
        var birthdate: NSDateComponents = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 2000;
        birthdate.month = 8;
        birthdate.day = 10;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)
        
        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 2
        player.name = "Clément J."
        player.gender = "Man"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 2003;
        birthdate.month = 6;
        birthdate.day = 13;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)
        
        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 3
        player.name = "Jean-Noel J."
        player.gender = "Man"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1972;
        birthdate.month = 1;
        birthdate.day = 24;
        player.birthday = birthdate.date as! NSDate

        players.update(with: player)
        
        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 4
        player.name = "Christelle J."
        player.gender = "Woman"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1973;
        birthdate.month = 4;
        birthdate.day = 10;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)

        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 5
        player.name = "Matéo V."
        player.gender = "Man"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 2003;
        birthdate.month = 7;
        birthdate.day = 25;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)

        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 6
        player.name = "Mayra V."
        player.gender = "Woman"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 2000;
        birthdate.month = 8;
        birthdate.day = 2;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)
        
        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 7
        player.name = "Jean-Charles V."
        player.gender = "Man"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1962;
        birthdate.month = 2;
        birthdate.day = 10;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)

        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 8
        player.name = "Nell V."
        player.gender = "Woman"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1965;
        birthdate.month = 4;
        birthdate.day = 20;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)

        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 9
        player.name = "Boris L."
        player.gender = "Man"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1984;
        birthdate.month = 5;
        birthdate.day = 28;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)

        player = PlayerMO(entity: self.entity, insertInto: self.managedContext)
        player.id = 10
        player.name = "Mélanie L."
        player.gender = "Woman"
        birthdate = NSDateComponents();
        birthdate.calendar = calendar;
        birthdate.year = 1982;
        birthdate.month = 4;
        birthdate.day = 6;
        player.birthday = birthdate.date as! NSDate
        players.update(with: player)
        
        return Array(players)
    }

    public func save(player: PlayerMO) {
        print("Player item is about to be saved from the current context")
        
        if let context = player.managedObjectContext {
            do {
                try context.save()
                print("->Save successfull")
                
                if !self._players.contains(player) {
                    self._players.append(player)
                    print("->Add successfull")
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
//    public static func save(player: PlayerMO) {
//        print("Player item is about to be saved from the current context")
//        
//        if let context = player.managedObjectContext {
//            do {
//                try context.save()
//                print("->Save successfull")
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }
    
    public func delete(player: PlayerMO) {
        print("Player item is about to be deleted from the current context")
        
        if let context = player.managedObjectContext {
            context.delete(player)
            print("->Delete successfull")
            
            if self._players.contains(player) {
                if let index = self._players.index(of: player) {
                    self._players.remove(at: index)
                    print("->Remove successfull")
                }
            }
        }
    }
    
    public func find(name: String) -> PlayerMO? {
        for player in self._players {
            if player.name == name {
                    return player
            }
        }
    
        return nil;
    }
}

