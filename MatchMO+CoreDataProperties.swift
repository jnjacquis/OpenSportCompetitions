//
//  MatchMO+CoreDataProperties.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


extension MatchMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchMO> {
        return NSFetchRequest<MatchMO>(entityName: "Match")
    }

    @NSManaged public var scoreCompetitor1: Int16
    @NSManaged public var scoreCompetitor2: Int16
    @NSManaged public var id: Int16
    @NSManaged public var competitionId: CompetitionMO?
    @NSManaged public var stageId: CompetitionStageMO?
    @NSManaged public var competitor1: CompetitorMO?
    @NSManaged public var competitor2: CompetitorMO?

}
