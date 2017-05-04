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

class CompetitionViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var competitionTitle: UITextField!
    @IBOutlet weak var competitionSport: UITextField!
    //@IBOutlet weak var competitionStartDate: UIDatePicker!
    //@IBOutlet weak var competitionEndDate: UIDatePicker!
    @IBOutlet weak var competitionCompetitorType: UISegmentedControl!
    @IBOutlet weak var competitionCompetitors: UITableView!
    @IBOutlet weak var competitionStages: UITableView!
    
    public var competition: CompetitionMO!
    
//    var competitorsDataSource: CompetitionCompetitorsDataSource
//    var stagesDataSource: CompetitionStagesDataSource
    
//    override init(nibName nibNameOrNil: String?,
//                  bundle nibBundleOrNil: Bundle?) {
//        self.competitorsDataSource = CompetitionCompetitorsDataSource(competition: self.competition)
//        self.stagesDataSource = CompetitionStagesDataSource(competition: self.competition)
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        self.competitorsDataSource = CompetitionCompetitorsDataSource(competition: self.competition)
//        self.stagesDataSource = CompetitionStagesDataSource(competition: self.competition)
//        super.init(coder: aDecoder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.competitionCompetitors.dataSource = self
        self.competitionStages.dataSource = self
        
        if let compet = try self.competition {
            self.competitionTitle.text = compet.title
            self.competitionSport.text = compet.sport
//            if let startDate = compet.startDate {
//                self.competitionStartDate.date = startDate as Date
//            }
//            if let endDate = compet.endDate {
//                self.competitionEndDate.date = endDate as Date
//            }
            
            if compet.competitorType == 0 {
                self.competitionCompetitorType.selectedSegmentIndex = 0
                    
            } else {
                self.competitionCompetitorType.selectedSegmentIndex = 1
                    
            }
            
//            if compet.stages == nil || compet.stages?.count == 0 {
//                compet.stages = NSMutableSet()
//                
//                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//
//                    let managedContext = appDelegate.persistentContainer.viewContext
//                    let entity = NSEntityDescription.entity(forEntityName: "CompetitionStage", in: managedContext)!
//                    let firstStage = CompetitionStageMO(entity: entity, insertInto: managedContext)
//                    
//                    compet.stages?.add(firstStage)
//                    
//                }
//            }
            
            //self.competitionCompetitors.reloadData()
            //self.competitionStages.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.competitionCompetitors.reloadData()
        self.competitionStages.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let competition = self.competition else {
            return 0
        }
        
        if tableView == self.competitionCompetitors {
            guard let competitorsCount = competition.competitors?.count else {
                return 0
            }
            
            return competitorsCount
        } else if tableView == self.competitionStages {
            guard let stagesCount = competition.stages?.count else {
                return 0
            }
            
            return stagesCount
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.competitionCompetitors {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "CellCompetitor")
        
        let competitors: [CompetitorMO] = self.competition.competitors?.allObjects as! [CompetitorMO]
            let competitor = competitors[indexPath.row]
        
        cell!.textLabel!.text =
            competitor.value(forKey: "name") as? String
        
            return cell!
        } else {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "CellStage")
            
            let stages: [CompetitionStageMO] = self.competition.stages?.allObjects as! [CompetitionStageMO]
            let stage = stages[indexPath.row]
            
            cell!.textLabel!.text = stage.descript()
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if tableView == self.competitionCompetitors {
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
            
        } else {
            if editingStyle == .delete {
                guard let stages = self.competition.stages else {
                    return
                }
                
                let allStages = stages.allObjects as! [CompetitionStageMO]
                let selectedStage = allStages[indexPath.row]
                
                // Remove the selected competitor from its parent ie competition
                self.competition.stages?.remove(selectedStage)
                
                // Update the table view of members
                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if self.competition == nil {
            self.competition = CompetitionMO(entity: CompetitionsDataService.instance.entity, insertInto: CompetitionsDataService.instance.managedContext)
            
            // If the title has been defined
            if let title = self.competitionTitle.text {
                self.competition.title = title
            }
        }
        
        self.competition.competitorType = Int16(self.competitionCompetitorType.selectedSegmentIndex)
        
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
            guard let button: UIBarButtonItem = sender as! UIBarButtonItem else {
                return
            }
            
            guard let title = button.title else {
                return
            }
            
            guard title != "Cancel" && button.title != "Abandonner" else {
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
            else {
                if let idx = destinationController.competitions.index(of: self.competition) {
                    destinationController.competitions[idx] = self.competition
                    destinationController.filteredCompetitions[idx] = self.competition
                }
            }
        }
        
    }
    
    @IBAction func competitorTypeChanged(_ sender: Any) {
        if self.competitionCompetitors.numberOfRows(inSection: 0) == 0 {
            return
        }
        
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
        self.competitionCompetitors.reloadData()
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
    
    @IBAction func newStageAdded(_ segue: UIStoryboardSegue) {
        self.competitionStages.reloadData()
    }
}

