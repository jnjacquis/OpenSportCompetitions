//
//  CompetitionCompetitorsDataSource.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 02/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionCompetitorsDataSource: NSObject, UITableViewDataSource {
    
    let competition: CompetitionMO!
    
    init(competition: CompetitionMO) {
        self.competition = competition
        super.init()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let competition = self.competition, let competitorsCount = competition.competitors?.count else {
            return 0
        }
        
        return competitorsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let competitors: [CompetitorMO] = self.competition.competitors?.allObjects as! [CompetitorMO]
        let competitor = competitors[indexPath.row]
        
        cell!.textLabel!.text =
            competitor.value(forKey: "name") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let competitors = self.competition.competitors else {
                return
            }
            
            let allCompetitors = competitors.allObjects as! [CompetitorMO]
            let selectedCompetitor = allCompetitors[indexPath.row]
            
            // Remove the selected competitor from its parent ie competition
            self.competition.competitors?.remove(selectedCompetitor)
            
            // Update the table view of members
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
}
