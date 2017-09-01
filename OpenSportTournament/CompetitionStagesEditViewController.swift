//
//  CompetitionStagesEditViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 14/07/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionStagesEditViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var competition: CompetitionMO!


    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let competition = self.competition, let stagesCount = competition.stages?.count else {
            return 0
        }
        
        return stagesCount
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let stages: [CompetitionStageMO] = self.competition.stages?.allObjects as! [CompetitionStageMO]
        let stage = stages[indexPath.row]
        
        cell!.textLabel!.text =
            stage.descript()
        
        return cell!
    }
    
    @IBAction func createStage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Competition", bundle: nil)
        let controller: NewCompetitionStage = storyboard.instantiateViewController(withIdentifier: "newCompetitionStage") as! NewCompetitionStage
        controller.competition = self.competition
        self.navigationController?.pushViewController(controller, animated: false)
    }
}
