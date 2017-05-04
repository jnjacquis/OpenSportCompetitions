//
//  StagesManagementViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class StagesManagementViewController: UITableViewController {
    public var competition: CompetitionMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar.delegate = self
        
        self.tableView.setEditing(true, animated: false)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        if let competition = self.competition {
            if competition.stages == nil || competition.stages?.count == 0 {
                // Show alert
                let alert: UIAlertController = UIAlertController(title: "Switch competitor type", message: "A competition must have at least one stage defined", preferredStyle: .alert)
//                let cancelActionHandler = {
//                    (action: UIAlertAction!) -> Void in
//                    switch self.competitionCompetitorType.selectedSegmentIndex {
//                    case 0:
//                        self.competitionCompetitorType.selectedSegmentIndex = 1
//                    case 1:
//                        self.competitionCompetitorType.selectedSegmentIndex = 0
//                    default:
//                        break
//                    }
//                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
                alert.addAction(confirmAction)
                
                present(alert, animated: true, completion: nil)
            }
        }
        
        let butSingleElimination: UIButton = UIButton(type: .roundedRect)
        
        let butAllTogether: UIButton = UIButton(type: .roundedRect)
        
        self.view.addSubview(butSingleElimination)
        self.view.addSubview(butAllTogether)
        
    }
    
}
