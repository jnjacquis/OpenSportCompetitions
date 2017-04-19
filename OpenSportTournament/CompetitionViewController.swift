//
//  CompetitionViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//


import UIKit
import Foundation

class CompetitionViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var competitionTitle: UITextField!
    @IBOutlet weak var competitionSport: UITextField!
    @IBOutlet weak var competitionStartDate: UIDatePicker!
    @IBOutlet weak var competitionEndDate: UIDatePicker!
    @IBOutlet weak var competitionCompetitorType: UISegmentedControl!
    @IBOutlet weak var competitionCompetitors: UITableView!
    
    public var competition: CompetitionMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.competitionCompetitors.dataSource = self
        
        if let compet = try self.competition {
            self.competitionTitle.text = compet.title
            self.competitionSport.text = compet.sport
            if let startDate = compet.startDate {
                self.competitionStartDate.date = startDate as Date
            }
            if let endDate = compet.endDate {
                self.competitionEndDate.date = endDate as Date
            }
            
            if compet.competitorType == 0 {
                self.competitionCompetitorType.selectedSegmentIndex = 0
                    
            } else {
                self.competitionCompetitorType.selectedSegmentIndex = 1
                    
            }
            
            self.competitionCompetitors.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.competitionCompetitors.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let competition = self.competition, let competitorsCount = competition.competitors?.count else {
            return 0
        }
//        if let competition = self.competition  {
//            return (competition.competitors?.count)!
//        } else {
//            return 0
//        }
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCompetitorSelection" {
            
            if self.competition == nil {
                self.competition = CompetitionMO(entity: CompetitionsDataService.instance.entity, insertInto: CompetitionsDataService.instance.managedContext)
                
                // If the title has been defined
                if let title = self.competitionTitle.text {
                    self.competition.title = title
                }
                
            }
            
            if let navigationController = segue.destination as? UINavigationController {
                
                if let controller = navigationController.topViewController as? CompetitorsSelectionViewController {
                    controller.competition = self.competition
                }
            }
        } else {
            
            guard let button: UIBarButtonItem = sender as! UIBarButtonItem, button.title == "Save" else {
                return
            }
            
            self.competition.title = self.competitionTitle.text!
            
            // Save instance team in any case
            CompetitionsDataService.instance.save(competition: self.competition)
            
            let destinationController = segue.destination as! CompetitionsViewController
            
            if !destinationController.competitions.contains(self.competition) {
                destinationController.competitions.append(self.competition)
                destinationController.filteredCompetitions.append(self.competition)
            }
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        if let competition = self.competition {
            CompetitionsDataService.instance.save(competition: competition)
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didCompetitorsSelection(_ segue: UIStoryboardSegue) {
         self.competitionCompetitors.reloadData()
    }
    
    @IBAction func backFromCompetitorsSelection(_ segue: UIStoryboardSegue) {
        
    }
}

