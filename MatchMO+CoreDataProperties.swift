//
//  MatchMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 31/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension MatchMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchMO> {
        return NSFetchRequest<MatchMO>(entityName: "Match")
    }

    @NSManaged public var id: Int16
    @NSManaged public var scoreCompetitor1: Int16
    @NSManaged public var scoreCompetitor2: Int16
    @NSManaged public var status: Int16
    @NSManaged public var competitor1: CompetitorMO?
    @NSManaged public var competitor2: CompetitorMO?
    @NSManaged public var stage: CompetitionStageMO?
//    @NSManaged public var parent: MatchMO?
//    @NSManaged public var children: NSSet?

}

// MARK: Generated accessors for children
extension MatchMO {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: MatchMO)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: MatchMO)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}
