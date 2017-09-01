//
//  CompetitionStageMO+CoreDataClass.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 03/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import CoreData


public class CompetitionStageMO: NSManagedObject {
    public static func getFetchRequest() -> NSFetchRequest<CompetitionStageMO> {
        return CompetitionStageMO.fetchRequest()
    }
    
    public func descript() -> String {
        var type: String? = nil
        switch self.type {
        case 0:
            type = "Single elimination"
            break
        case 1:
            type = "Pool"
            break
        default:
            type = ""
        }
        
        return "Stage #" + String(self.id) + " - " + type!
    }
}
