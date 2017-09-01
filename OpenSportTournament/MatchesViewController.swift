//
//  MatchsViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 04/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class MatchesViewController: UITableViewController {
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    var stages = [CompetitionStageMO]()
    var filteredStages = [CompetitionStageMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var previousSearchLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar.delegate = self
        print(self.tableView.allowsSelection)
        print(self.tableView.allowsMultipleSelection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let activeStages = CompetitionStagesDataService.instance.queryActiveStages()
        
        self.stages = activeStages.sorted { $0.id < $1.id }
        self.filteredStages = self.stages
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.stages.count
    }

//    override func tableView(_ tableView: UITableView,
//                   viewForHeaderInSection section: Int) -> UIView? {
//        let frame: CGRect = tableView.frame
//        
//        let addButton: UIButton = UIButton(frame: CGRect(x: frame.size.width-200, y: 10, width: 200, height: 30))
//        addButton.setTitle("Next match", for: .normal)
//        addButton.backgroundColor = .green
//        addButton.addTarget(self, action: #selector(MatchesViewController.nextMatch(_:stage:)), for: .touchUpInside)
//        
//        let title: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 400, height: 30))
//        title.text = self.stages[section].competition?.title
//        
//        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
//        headerView.addSubview(title)
//        headerView.addSubview(addButton)
//        
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.stages[section].competition?.title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let stage = self.stages[section]
        
        guard let matches = stage.matches else {
            return 0
        }
        return matches.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "CellMatch")
        cell?.isEditing = false
        
        
        let match: MatchMO = filteredStages[indexPath.section].matches?.allObjects[indexPath.row] as! MatchMO
        
        var cellText: String = ""
        var detailText: String = ""
        let idValue = match.value(forKey: "id")
        if let value = idValue {
            print(value)
            cellText = "Match #" + String(value as! Int)
        }
        
        if let competitor1 = match.competitor1, let competitor2 = match.competitor2 {
            cellText = cellText + " - " + competitor1.name! + " vs " + competitor2.name!
            
            if match.status == 2 {
                detailText = String(match.scoreCompetitor1) + " - " + String(match.scoreCompetitor2)
            }
        }
        
        cell!.isEditing = true
        
        if match.status == 0 || match.status == 1 {
            // Create button programmatically to set the action according to the status of the current match
            let content = cell!.contentView
            print(content.bounds)

            let button = UIButton(frame: CGRect(x: content.bounds.width, y: 0, width: 100, height: content.bounds.height))
            
            if match.status == 0 {
                button.setTitle("Start", for: .normal)
                button.backgroundColor = UIColor.green
                button.addTarget(self, action: #selector(startMatch(_:)), for: .touchUpInside)
            }
            else {
                button.setTitle("Set scores", for: .normal)
                button.backgroundColor = UIColor.blue
                button.addTarget(self, action: #selector(setMatchResult(_:)), for: .touchUpInside)
            }
            
            content.addSubview(button)
            
        }
        
        cell!.textLabel!.text = cellText
        
        if match.status == 2 {
            cell!.detailTextLabel!.text = detailText
        }
        else {
            cell!.detailTextLabel!.text = indexPath.description
            cell!.detailTextLabel?.isHidden = true
        }
        
        return cell!
    }
    
    @IBAction func startMatch(_ sender: AnyObject) {
        let originButton: UIButton = sender as! UIButton
        var touchPoint = originButton.convert(CGPoint.zero, to: self.tableView)
        
        guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
            return
        }

        NSLog("index path.section ==%ld", Int((indexPath.section)))
        NSLog("index path.row ==%ld", Int((indexPath.row)))

        let stage = self.stages[indexPath.section] as CompetitionStageMO
        
        guard let stageMatches = stage.matches else {
            return
        }
        
        let matches = stageMatches.allObjects as! [MatchMO]
        let match = matches[indexPath.row]
        
        // Update and save the match's status
        match.status = 1 // Means 'started'
        MatchsDataService.instance.save(match: match)

        // Update the UI
        self.tableView.reloadData()
    }
    
    @IBAction func setMatchResult(_ sender: AnyObject) {
        let originButton: UIButton = sender as! UIButton
        var touchPoint = originButton.convert(CGPoint.zero, to: self.tableView)
        
        guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        
        NSLog("index path.section ==%ld", Int((indexPath.section)))
        NSLog("index path.row ==%ld", Int((indexPath.row)))
        
        let stage = self.stages[indexPath.section] as CompetitionStageMO
        
        guard let stageMatches = stage.matches else {
            return
        }
        
        let matches = stageMatches.allObjects as! [MatchMO]
        let match = matches[indexPath.row]
        
        // Go to the matches view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "matchResultVC") as! MatchResultViewController
        controller.match = match
        self.present(controller, animated: true, completion: nil)
        
        // Update and save the match's status
        match.status = 2 // Means 'ended'
        //MatchsDataService.instance.save(match: match)
    }
    
    
//    @IBAction func nextMatch(_ sender: AnyObject, stage: CompetitionStageMO) {
//        let appDelegate =
//            UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Match", in: managedContext)!
//        
//        var competitors = self.stages[0].competitors?.allObjects as! [CompetitorMO]
//        
//        let nextCompetitors = SingleEliminationGeneration.computeMatches(self.stages[0])
//        
//        if let nextOnes = nextCompetitors {
//            // Create new/next match
//            let match = MatchMO(entity: entity, insertInto: managedContext)
//            match.competitor1 = nextOnes.0
//            match.competitor2 = nextOnes.1
//            
//            self.stages[0].matches?.adding(match)
//            
//            // Check if stage's type is single elimination
//            if self.stages[0].type == 0 {
//                // Remove the 2 previous competitors from the list
//                if let index = competitors.index(of: nextOnes.0) {
//                    competitors.remove(at: index)
//                }
//                if let index = competitors.index(of: nextOnes.1) {
//                    competitors.remove(at: index)
//                }
//            }
//            
//            // Save current stage
//            CompetitionStagesDataService.instance.save(stage: self.stages[0])
//        }
//        
//    }
}
