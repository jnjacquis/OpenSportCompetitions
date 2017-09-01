//
//  CompetitionViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CompetitionEditViewController: UIViewController {
    
    @IBOutlet weak var competitionTitle: UITextField!
    @IBOutlet weak var competitionSport: UITextField!
    @IBOutlet weak var competitionCompetitorType: UISegmentedControl!
    
    public var competition: CompetitionMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.competition == nil {
            // Create instance of entity and set its properties from the view fields
            self.competition = CompetitionMO(entity: CompetitionsDataService.instance.entity, insertInto: CompetitionsDataService.instance.managedContext)
            self.competition.active = false
        }
        
        if let compet = try self.competition {
            self.competitionTitle.text = compet.title
            self.competitionSport.text = compet.sport
            
            if compet.competitorType == 0 {
                self.competitionCompetitorType.selectedSegmentIndex = 0
                    
            } else {
                self.competitionCompetitorType.selectedSegmentIndex = 1
                    
            }
            
            if let sport = self.competition.sport {
                self.competitionSport.text = sport
            }
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        
        if let destVC = dest as? CompetitionStagesEditViewController {
            destVC.competition = self.competition
        }
        if let destVC = dest as? CompetitionCompetitorsEditViewController {
            destVC.competition = self.competition
        }
        
        
        if segue.identifier == "showCompetitorSelection" {
            
            if let navigationController = segue.destination as? UINavigationController {
                
                if let controller = navigationController.topViewController as? CompetitorsSelectionViewController {
                    controller.competition = self.competition
                }
            }
        } else if segue.identifier == "showStagesManagement" {
            
            if let navigationController = segue.destination as? UINavigationController {
                
                if let controller = navigationController.topViewController as? StagesManagementViewController {
                    controller.competition = self.competition
                }
            }
        } else if segue.identifier == "createStage" {
            print(segue.destination)
            //if let navigationController = segue.destination as? UINavigationController {
    
                if let controller = segue.destination as? NewCompetitionStage {
                    controller.competition = self.competition
                }
            //}
        } else {
//            guard let button: UIBarButtonItem = sender as! UIBarButtonItem else {
//                return
//            }
//            
//            guard let title = button.title else {
//                return
//            }
//            
//            guard title != "Cancel" && button.title != "Abandonner" else {
//                return
//            }
//            
//            self.competition.title = self.competitionTitle.text!
//            
//            // Save instance team in any case
//            CompetitionsDataService.instance.save(competition: self.competition)
//            
//            let destinationController = segue.destination as! CompetitionsViewController
//            
//            if !destinationController.competitions.contains(self.competition) {
//                destinationController.competitions.append(self.competition)
//                destinationController.filteredCompetitions.append(self.competition)
//            }
//            else {
//                if let idx = destinationController.competitions.index(of: self.competition) {
//                    destinationController.competitions[idx] = self.competition
//                    destinationController.filteredCompetitions[idx] = self.competition
//                }
//            }
        }
        
    }
    
    @IBAction func competitorTypeChanged(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Switch competitor type", message: "By switching competitor's type, you are about to remove all the competitors in the list", preferredStyle: .alert)
        let cancelActionHandler = {
            (action: UIAlertAction!) -> Void in
            switch self.competitionCompetitorType.selectedSegmentIndex {
            case 0:
                self.competitionCompetitorType.selectedSegmentIndex = 1
            case 1:
                self.competitionCompetitorType.selectedSegmentIndex = 0
            default:
                break
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionHandler)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: self.confirmAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func confirmAction(alertAction: UIAlertAction!) {
        self.competition.competitors?.removeAllObjects()
    }
        
    @IBAction func save(_ sender: Any) {
        if let competition = self.competition {
            competition.title = self.competitionTitle.text
            competition.sport = self.competitionSport.text
            competition.competitorType = Int16(Int(self.competitionCompetitorType.selectedSegmentIndex))
            
            CompetitionsDataService.instance.save(competition: competition)
        }
        
        self.navigationController?.popViewController(animated: false)
    }

    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

