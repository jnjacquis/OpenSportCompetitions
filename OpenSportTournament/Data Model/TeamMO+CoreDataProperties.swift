//
//  TeamMO+CoreDataProperties.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 11/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension TeamMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamMO> {
        return NSFetchRequest<TeamMO>(entityName: "Team")
    }

    @NSManaged public var id: Int16
    @NSManaged public var members: NSMutableSet?

}

// MARK: Generated accessors for members
extension TeamMO {

    @objc(insertObject:inMembersAtIndex:)
    @NSManaged public func insertIntoMembers(_ value: PlayerMO, at idx: Int)

    @objc(removeObjectFromMembersAtIndex:)
    @NSManaged public func removeFromMembers(at idx: Int)

    @objc(insertMembers:atIndexes:)
    @NSManaged public func insertIntoMembers(_ values: [PlayerMO], at indexes: NSIndexSet)

    @objc(removeMembersAtIndexes:)
    @NSManaged public func removeFromMembers(at indexes: NSIndexSet)

    @objc(replaceObjectInMembersAtIndex:withObject:)
    @NSManaged public func replaceMembers(at idx: Int, with value: PlayerMO)

    @objc(replaceMembersAtIndexes:withMembers:)
    @NSManaged public func replaceMembers(at indexes: NSIndexSet, with values: [PlayerMO])

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: PlayerMO)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: PlayerMO)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSOrderedSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSOrderedSet)

}
