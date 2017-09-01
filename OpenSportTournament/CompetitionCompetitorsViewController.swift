//
//  CompetitionCompetitorsViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 04/07/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionCompetitorsViewController: UITableViewController {
    
    public var competition: CompetitionMO!
    
    //var competitors = [CompetitorMO]()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //self.searchBar.delegate = self
//             
//        guard let competition = self.competition else {
//            return
//        }
//        
//        if competition.competitorType == 0 {
//            let allPlayers = PlayersDataService.instance.players
//            let sortedPlayers = allPlayers.sorted { $0.name! < $1.name! }
//            self.competitors = sortedPlayers as [CompetitorMO]
//        }
//        else {
//            let allTeams = TeamsDataService.instance.teams
//            let sortedTeams = allTeams.sorted { $0.name! < $1.name! }
//            self.competitors = sortedTeams as [CompetitorMO]
//        }
//    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        guard let competition = self.competition, let competitorsCount = competition.competitors?.count else {
            return 0
        }
        
        return competitorsCount
    }
    
    override func tableView(_ tableView: UITableView,
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
    
//    override func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCellEditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            guard let competitors = self.competition.competitors else {
//                return
//            }
//            
//            let allCompetitors = competitors.allObjects as! [CompetitorMO]
//            let selectedCompetitor = allCompetitors[indexPath.row]
//            
//            // Remove the selected competitor from its parent ie competition
//            self.competition.competitors?.remove(selectedCompetitor)
//            
//            // Update the table view of members
//            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is CompetitionCompetitorsEditViewController {
//            let destVC = segue.destination as! CompetitionCompetitorsEditViewController
//            destVC.competition = self.competition
//        }
//    }
}
