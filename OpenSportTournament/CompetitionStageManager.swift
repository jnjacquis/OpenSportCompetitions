//
//  CompetitionStageManager.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 11/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation

protocol MatchesGenerator {
    static func computeMatches(_ stage: CompetitionStageMO) -> [MatchMO]
}
