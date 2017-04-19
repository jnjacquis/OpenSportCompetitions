//
//  PlayerMO+CoreDataClass.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 11/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


public class PlayerMO: CompetitorMO {
    public static func getFetchRequest() -> NSFetchRequest<PlayerMO> {
        return PlayerMO.fetchRequest()
    }
}
