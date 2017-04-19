//
//  TeamMO+CoreDataClass.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 11/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


public class TeamMO: CompetitorMO {
    public static func getFetchRequest() -> NSFetchRequest<TeamMO> {
        return TeamMO.fetchRequest()
    }
}
