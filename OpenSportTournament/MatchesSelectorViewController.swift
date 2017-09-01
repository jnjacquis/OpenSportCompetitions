//
//  MatchesSelectorViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 15/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit

class MatchesSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var matchStatusSelector: UISegmentedControl!
    //@IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var previousCompetitionStage: UIBarButtonItem!
    @IBOutlet weak var nextCompetitionStage: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var activeStages: [CompetitionStageMO] = []
    var stage: CompetitionStageMO?
    
    var matches = [MatchMO]()
    var matchesByStatus: [[MatchMO]] = [[MatchMO]]()
    var matchesToDisplay: [MatchMO] = [MatchMO]()
    
    public var previousSelector: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.activeStages.count == 0 {
            self.activeStages = CompetitionStagesDataService.instance.queryActiveStages()
        }
        
        if self.stage == nil {
            self.stage = self.activeStages.last
        }
        
        // Set title of the view controller
        self.navigationTitle.title = "Matches of " + (self.stage?.competition?.title)!
        
        self.matches = self.stage?.matches?.allObjects as! [MatchMO]
        self.matchesByStatus = [[MatchMO]]()
        var matches = self.matches.filter { $0.status == 0 }
        self.matchesByStatus.append(matches)
        matches = self.matches.filter { $0.status == 1 }
        self.matchesByStatus.append(matches)
        matches = self.matches.filter { $0.status == 2 }
        self.matchesByStatus.append(matches)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Hide or show navigation button depending on the current stage displayed
        let index = self.activeStages.index(of: self.stage!)
        print("Index of the current active stage: " + index!.description)
        print("Start index: " + self.activeStages.startIndex.description)
        if index == self.activeStages.startIndex {
            self.navigationTitle.leftBarButtonItem?.isEnabled = false
        } else {
            self.navigationTitle.leftBarButtonItem?.isEnabled = true
        }
        print("End index: " + self.activeStages.endIndex.description)
        if index == self.activeStages.endIndex - 1 {
            self.navigationTitle.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationTitle.rightBarButtonItem?.isEnabled = true
        }
        
        self.tableView.setNeedsDisplay()
        //self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // Number of sections depends on the selection in the segmented control, but 3 is the default
        let index = self.matchStatusSelector.selectedSegmentIndex
        
        switch index {
        case 0:
            return 3
        case 1,2,3:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = self.matchStatusSelector.selectedSegmentIndex
        var title = ""
        
        switch index {
        case 0:
            switch section {
            case 0:
                title = "Not started"
            case 1:
                title = "In progress"
            case 2:
                title = "Ended"
            default:
                title = ""
            }
        case 1,2,3:
            
            // Substract 1 to index as the case above starts at 1
            switch (index - 1) {
            case 0:
                title = "Not started"
            case 1:
                title = "In progress"
            case 2:
                title = "Ended"
            default:
                title = ""
            }
        default:
            title = ""
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // Get the selected  index of the segmented control
        let selectedIndex = self.matchStatusSelector.selectedSegmentIndex
        var numberOfRows = 0
        
        if selectedIndex == 0 {
            numberOfRows = self.matchesByStatus[section].count
        } else {
            numberOfRows = self.matchesByStatus[selectedIndex - 1].count
        }

        print("Number of rows in section #" + String(section) + ": " + String(numberOfRows))
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {

        var match: MatchMO? = nil
        
        // Get the selected  index of the segmented control
        let selectedIndex = self.matchStatusSelector.selectedSegmentIndex
        
        if selectedIndex == 0 {
            match = self.matchesByStatus[indexPath.section][indexPath.row]
        } else {
            match = self.matchesByStatus[selectedIndex - 1][indexPath.row]
        }
        
        // Get the tableview cell depending on the match's status
        var cell: UITableViewCell? = nil
        if match?.status == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CellMatchResult")
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CellMatch")
        }
        cell?.isEditing = false
        
        var cellText: String = ""
        //var detailText: String = ""
        
        //let idValue = match?.value(forKey: "id")
        //if let value = idValue {
        //    print(value)
        //    cellText = "Match #" + String(value as! Int)
        //}
        
        if let competitor1 = match?.competitor1, let competitor2 = match?.competitor2 {
            
            if match?.status == 2 {
                let sviews = cell?.contentView.subviews
                // Display competitor's name with his score
                //let labelCompetitorsNames = cell?.contentView.subviews[0] as! UILabel
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.text = competitor1.name! + " vs " + competitor2.name!
                //let labelCompetitorsScores = cell?.contentView.subviews[1] as! UILabel
                cell?.detailTextLabel?.textAlignment = .center
                cell?.detailTextLabel?.text = String(match?.scoreCompetitor1 ?? 0) + " / " + String(match?.scoreCompetitor2 ?? 0)

                
                //let labelCompetitor2 = cell?.contentView.subviews[1] as! UILabel
                //labelCompetitor2.text = competitor2.name!
                //let labelCompetitor2Score = cell?.contentView.subviews[3] as! UILabel
                //labelCompetitor2Score.text = match?.scoreCompetitor2.description
                
            } else {
                // Display only competitor's name
                cellText = cellText + " - " + competitor1.name! + " vs " + competitor2.name!
            
                let secondSubview = cell?.contentView.subviews[0]
                if let label = secondSubview as? UILabel {
                    label.text = cellText
                }
                
                cell!.isEditing = true
                let firstSubview = cell?.contentView.subviews[1]
                
                if let button = firstSubview as? UIButton {
                    if match?.status == 0 {
                        button.isHidden = false
                        button.setTitle("Start", for: .normal)
                        button.backgroundColor = UIColor.green
                        button.addTarget(self, action: #selector(startMatch(_:)), for: .touchUpInside)
                    }
                    else if match?.status == 1 {
                        button.isHidden = false
                        button.setTitle("Set scores", for: .normal)
                        button.backgroundColor = UIColor.blue
                        button.removeTarget(self, action: #selector(startMatch(_:)), for: .touchUpInside)
                        button.addTarget(self, action: #selector(setMatchResult(_:)), for: .touchUpInside)
                    }
                    else {
                        button.isHidden = true
                        button.removeTarget(self, action: #selector(setMatchResult(_:)), for: .touchUpInside)
                    }
                }
            }
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

        let matches = matchesByStatus[indexPath.section]
        let match = matches[indexPath.row]
        
        // Update and save the match's status
        match.status = 1 // Means 'started'
        MatchsDataService.instance.save(match: match)
        
        // Manually manage the match in the lists
        self.matchesByStatus[0].remove(at: self.matchesByStatus[0].index(of: match)!)
        self.matchesByStatus[1].append(match)
        
        // Update the UI
        self.tableView.reloadData()
    }
    
    @IBAction func statusValueChanged(_ sender: Any) {
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
        
        let matches = matchesByStatus[indexPath.section]
        let match = matches[indexPath.row]
        
        let alert = UIAlertController(title: "Match result", message: nil, preferredStyle:  .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) -> Void in
            // Set score entered in alert for each competitor
            let firstScoreField = alert.textFields![0] as UITextField
            let secondScoreField = alert.textFields![1] as UITextField
            
            match.scoreCompetitor1 = Int16(firstScoreField.text!)!
            match.scoreCompetitor2 = Int16(secondScoreField.text!)!
            
            match.status = 2 // Means 'ended'
            MatchsDataService.instance.save(match: match)
            
            // Manually manage the match in the lists
            if let index = self.matchesByStatus[1].index(of: match) {
                self.matchesByStatus[1].remove(at: index)
                self.matchesByStatus[2].append(match)
            }
            
            // Update the UI
            self.tableView.reloadData()
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Score of competitor " + (match.competitor1?.name)!
            textField.textAlignment = .left
            textField.keyboardType = .numberPad
        })
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Score of competitor " + (match.competitor2?.name)!
            textField.textAlignment = .left
            textField.keyboardType = .numberPad
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goPreviousCompetitionStage(_ sender: Any) {

        if let index = self.activeStages.index(of: self.stage!) {
            if (index - 1) >= self.activeStages.startIndex {
                self.stage = self.activeStages[index - 1]
            }
            
            self.viewWillAppear(true)
        }
        
        self.tableView.reloadData()
    }
   
    @IBAction func goNextCompetitionStage(_ sender: Any) {
        
        if let index = self.activeStages.index(of: self.stage!) {
            if (index - 1) <= self.activeStages.endIndex {
                self.stage = self.activeStages[index + 1]
            }
            
            self.viewWillAppear(true)
        }
        
        self.tableView.reloadData()
    }
    
}

