//
//  PlayerMO+CoreDataProperties.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 11/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension PlayerMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerMO> {
        return NSFetchRequest<PlayerMO>(entityName: "Player")
    }

    @NSManaged public var birthday: NSDate?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int32
    @NSManaged public var team: TeamMO?
    @NSManaged public var ranking: String?
}
