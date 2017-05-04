//
//  CompetitionStageMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 03/05/2017.
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
    @NSManaged public var competitionId: CompetitionMO?
    @NSManaged public var competitors: CompetitorMO?

}
