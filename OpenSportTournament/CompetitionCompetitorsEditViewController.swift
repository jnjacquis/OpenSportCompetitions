//
//  CompetitionCompetitorsEditViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 05/07/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionCompetitorsEditViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var competition: CompetitionMO!
    
    var competitors = [CompetitorMO]()
    var filteredCompetitors = [CompetitorMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var previousSearchLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar.delegate = self
        
        self.tableView.setEditing(true, animated: false)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        guard let competition = self.competition else {
            return
        }
        
        if competition.competitorType == 0 {
            let allPlayers = PlayersDataService.instance.players
            let sortedPlayers = allPlayers.sorted { $0.name! < $1.name! }
            self.competitors = sortedPlayers as [CompetitorMO]
            self.filteredCompetitors = self.competitors
        }
        else {
            let allTeams = TeamsDataService.instance.teams
            let sortedTeams = allTeams.sorted { $0.name! < $1.name! }
            self.competitors = sortedTeams as [CompetitorMO]
            self.filteredCompetitors = self.competitors
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredCompetitors.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let player = filteredCompetitors[indexPath.row]
        
        
        cell!.textLabel!.text =
            player.value(forKey: "name") as? String
        
        if (self.competition.competitors?.contains(player))! {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
        
        return cell!
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredCompetitors = self.competitors.filter({( competitor : CompetitorMO) -> Bool in
            return (competitor.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveCompetitors() {
        // Remove all members from the current team, even if no members are selected in the table view
        self.competition.competitors?.removeAllObjects()
        
        if let indexes = self.tableView.indexPathsForSelectedRows {
            
            for index in indexes {
                let competitor = self.filteredCompetitors[index.row]
                self.competition.competitors?.add(competitor)
            }
        }
//        let navCtrl = self.navigationController as! UINavigationController
//        if let competitionCompetitorsVC = self.navigationController?.viewControllers[2] as? CompetitionCompetitorsViewController {
//            competitionCompetitorsVC.competition = self.competition
//            competitionCompetitorsVC.tableView.setNeedsDisplay()
//        }
        
        self.navigationController?.popViewController(animated: false)
    }
}

//extension MembersSelectionViewController: UISearchBarDelegate {
//    // MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!)
//    }
//    
//    func searchBar(_: UISearchBar, textDidChange: String) {
//        
//        if textDidChange.isEmpty {
//            
//            self.filteredPlayers = self.players
//            self.tableView.reloadData()
//        }
//        else {
//            self.filterContentForSearchText(textDidChange)
//        }
//    }
//}

//extension MembersSelectionViewController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
//}


