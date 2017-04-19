//
//  CompetitionMO.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 21/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import CoreData

class CompetitionMO: NSManagedObject {
    
    @NSManaged public var title: String?
    @NSManaged public var sport: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: Int32
    @NSManaged public var competitorType: Int16
    @NSManaged public var competitors: NSMutableSet?
    @NSManaged public var status: UInt8
}
