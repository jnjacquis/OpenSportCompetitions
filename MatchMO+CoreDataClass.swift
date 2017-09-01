//
//  MatchMO+CoreDataClass.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


public class MatchMO: NSManagedObject {
    
//    private var _level: Int?
//    public var level: Int {
//        get {
//            return self._level!
//        }
//        set {
//            self._level = newValue
//        }
//    }
    
    public override var description: String {
        get {
            return "Match #(\(self.id): (\(competitor1?.name) vs (\(competitor2?.name))"
        }
    }
    
    public static func getFetchRequest() -> NSFetchRequest<MatchMO> {
        return MatchMO.fetchRequest()
    }
    
    
    public func getWinner() -> CompetitorMO? {
        if self.scoreCompetitor1 > self.scoreCompetitor2 {
            return self.competitor1
        } else if scoreCompetitor2 > self.scoreCompetitor1 {
            return self.competitor2
        } else {
            return nil
        }
    }
        
    public func isDraw() -> Bool {
        if self.scoreCompetitor1 == scoreCompetitor2 {
            return true
        } else {
            return false
        }
    }

}
