//
//  CompetitionStageMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 01/09/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension CompetitionStageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompetitionStageMO> {
        return NSFetchRequest<CompetitionStageMO>(entityName: "CompetitionStage")
    }

    @NSManaged public var active: Bool
    @NSManaged public var id: Int16
    @NSManaged public var type: Int16
    @NSManaged public var competition: CompetitionMO?
    @NSManaged public var competitors: NSSet?
    @NSManaged public var matches: NSSet?

}

// MARK: Generated accessors for competitors
extension CompetitionStageMO {

    @objc(addCompetitorsObject:)
    @NSManaged public func addToCompetitors(_ value: CompetitorMO)

    @objc(removeCompetitorsObject:)
    @NSManaged public func removeFromCompetitors(_ value: CompetitorMO)

    @objc(addCompetitors:)
    @NSManaged public func addToCompetitors(_ values: NSSet)

    @objc(removeCompetitors:)
    @NSManaged public func removeFromCompetitors(_ values: NSSet)
    

}

// MARK: Generated accessors for matches
extension CompetitionStageMO {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: MatchMO)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: MatchMO)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}
