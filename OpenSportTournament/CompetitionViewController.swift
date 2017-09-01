//
//  CompetitionViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 03/07/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionViewController: UIViewController {
    
    @IBOutlet weak var competitionTitle: UILabel!
    @IBOutlet weak var competitionSport: UILabel!
    @IBOutlet weak var competitionCompetitorType: UISegmentedControl!
    
    @IBOutlet weak var launchCompetition: UIButton!
    public var competition: CompetitionMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let compet = try self.competition {
            self.competitionTitle.text = compet.title
            self.competitionSport.text = compet.sport
            
            let competitor = compet.competitors?.allObjects
            
            if compet.active {
                self.launchCompetition.isHidden = true
            }

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        print(dest)
        
        let debug = self.competition?.competitors.debugDescription
        
        if let destVC = dest as? CompetitionCompetitorsViewController {
            destVC.competition = self.competition
        }
        if let destVC = dest as? CompetitionStagesViewController {
            destVC.competition = self.competition
        }
        if let destVC = dest as? CompetitionEditViewController {
            destVC.competition = self.competition
        }
    }
    
    @IBOutlet weak var launchButton: UIButton!
    
    @IBAction func launchCompetition(_ sender: Any) {
        // First check that stages have been defined
        guard self.competition.stages != nil && self.competition.stages?.count != 0 else {
            let alert = UIAlertController(title: "Check competition's stages", message: "The competition cannot be launched because no stages defined", preferredStyle: .alert)
            let cancelLaunchCompetition = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelLaunchCompetition)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Second check that competitors have been defined
        guard self.competition.competitors != nil && self.competition.competitors?.count != 0 else {
            let alert = UIAlertController(title: "Check competition's competitors", message: "The competition cannot be launched because no competitors", preferredStyle: .alert)
            let cancelLaunchCompetition = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelLaunchCompetition)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Alert the user that the competition is about to be lanched and that matches for the first stage will be computed
        let alert = UIAlertController(title: "Launch competition", message: "The competition is about to be launched and matches for the first stage will be computed", preferredStyle: .alert)
        let comfirmLaunchCompetition = UIAlertAction(title: "Confirm", style: .default, handler: {(alert: UIAlertAction!) in
            
            // Go to the matches view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Set the competition as active
            self.competition.active = true
            
            // Set the first stage as active
            if let stages = self.competition.stages {
                var items = stages.allObjects
                let firstStage = items[0] as! CompetitionStageMO
                firstStage.active = true
                
                // Set the competitors for the first stage as all the competition's competitors
                firstStage.competitors = self.competition.competitors
                
                // Compute all the matches for this stage depending on the stage's typ
                var matches = [MatchMO]()
                if firstStage.type == 0 {
                    matches = SingleEliminationGenerator.computeMatches(firstStage)
                } else {
                    let rootMatch: MatchMO = (PoolGenerator.computeMatches(firstStage)?.0.value)!
                    matches[0] = rootMatch
                }
                let stageMatches = NSMutableSet()
                stageMatches.addObjects(from: matches)
                firstStage.matches = stageMatches
                
                CompetitionStagesDataService.instance.save(stage: firstStage)
                
                let matchesViewController = storyboard.instantiateViewController(withIdentifier: "matchesVC") as! MatchesSelectorViewController
                matchesViewController.activeStages.append(firstStage)
                matchesViewController.stage = firstStage
            }
            
            // Save all modifications in Core Data
            CompetitionsDataService.instance.save(competition: self.competition)
            
            // Hide the 'Launch' button
            self.launchCompetition.isHidden = true
            
            //self.dismiss(animated: true, completion: nil)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "TarBarVC") as! UITabBarController
            controller.selectedIndex = 3
            self.present(controller, animated: true, completion: nil)
        })
        alert.addAction(comfirmLaunchCompetition)
        present(alert, animated: true, completion: nil)
    }
}
