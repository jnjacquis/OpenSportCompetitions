//
//  File.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 25/02/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import CoreData

class PlayerMO: CompetitorMO {
    
    @NSManaged public var birthday: Date?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int32
    //@NSManaged public var name: String?
}
