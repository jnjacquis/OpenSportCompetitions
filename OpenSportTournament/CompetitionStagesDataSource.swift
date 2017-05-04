//
//  CompetitionStagesDataSource.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit

class CompetitionStagesDataSource: NSObject, UITableViewDataSource {
    
    let competition: CompetitionMO
    
    init(competition: CompetitionMO) {
        self.competition = competition
        super.init()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard (self.competition.stages != nil) else {
            return 0
        }
        return (self.competition.stages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let stages: [CompetitionStageMO] = self.competition.stages?.allObjects as! [CompetitionStageMO]
        let stage = stages[indexPath.row]
        
        cell!.textLabel!.text = "Stage #" +
            (stage.value(forKey: "id") as? String)!
        
        return cell!
    }
    
}
