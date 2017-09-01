//
//  CompetitorMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 02/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension CompetitorMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompetitorMO> {
        return NSFetchRequest<CompetitorMO>(entityName: "Competitor")
    }

    @NSManaged public var active: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var competition: CompetitionMO?

}
