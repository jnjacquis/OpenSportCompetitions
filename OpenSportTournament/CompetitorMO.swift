//
//  CompetitorMO.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import CoreData

class CompetitorMO: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var active: Bool
    @NSManaged public var competition: CompetitionMO?
    
}
