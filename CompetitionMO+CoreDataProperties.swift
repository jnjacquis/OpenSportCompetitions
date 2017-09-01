//
//  CompetitionMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension CompetitionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompetitionMO> {
        return NSFetchRequest<CompetitionMO>(entityName: "Competition")
    }

    @NSManaged public var active: Bool
    @NSManaged public var competitorType: Int16
    @NSManaged public var endDate: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var sport: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var competitors: NSMutableSet?
    @NSManaged public var stages: NSMutableSet?

}

// MARK: Generated accessors for competitors
extension CompetitionMO {

    @objc(addCompetitorsObject:)
    @NSManaged public func addToCompetitors(_ value: CompetitorMO)

    @objc(removeCompetitorsObject:)
    @NSManaged public func removeFromCompetitors(_ value: CompetitorMO)

    @objc(addCompetitors:)
    @NSManaged public func addToCompetitors(_ values: NSSet)

    @objc(removeCompetitors:)
    @NSManaged public func removeFromCompetitors(_ values: NSSet)

}
