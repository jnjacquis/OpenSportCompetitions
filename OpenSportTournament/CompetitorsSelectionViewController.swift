//
//  CompetitorsSelectionViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 24/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class CompetitorsSelectionViewController: UITableViewController {
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var competitorType: UInt8 = 0
    
    var competitors = [CompetitorMO]()
    var filteredCompetitors = [CompetitorMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var competition: CompetitionMO!
    
    public var previousSearchLength: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(coder aDecoder: NSCoder, competitor type: UInt8) {
        super.init(coder: aDecoder)
        
        self.competitorType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.tableView.setEditing(true, animated: false)
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var allCompetitors = [CompetitorMO]()
        
        if self.competition.competitorType == 0 {
            allCompetitors = PlayersDataService.instance.players as [CompetitorMO]
        } else {
            allCompetitors = TeamsDataService.instance.teams as [CompetitorMO]
        }
        
        self.competitors = allCompetitors.sorted { $0.name! < $1.name! }
        self.filteredCompetitors = self.competitors
    }
    
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
        
        let competitor = filteredCompetitors[indexPath.row]
        
        cell!.textLabel!.text =
            competitor.value(forKey: "name") as? String

        if (self.competition.competitors?.contains(competitor))! {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
        
        return cell!
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredCompetitors = self.competitors.filter({( competition : CompetitorMO) -> Bool in
            return (competition.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    @IBAction func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveCompetitors() {
        // Remove all competitors from the current competition, even if no competitors are selected in the table view
        self.competition.competitors?.removeAllObjects()
        
        if let indexes = self.tableView.indexPathsForSelectedRows {
            
            for index in indexes {
                let competitor = self.filteredCompetitors[index.row]
                self.competition.competitors?.add(competitor)
            }
        }
        
        // Instantiate destination view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let competitionViewController = storyboard.instantiateViewController(withIdentifier: "competitionViewController") as! CompetitionViewController
        competitionViewController.competition = self.competition

        dismiss(animated: false, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Remove all competitors from the current competition, even if no competitors are selected in the table view
        self.competition.competitors?.removeAllObjects()
        
        if let indexes = self.tableView.indexPathsForSelectedRows {
            
            for index in indexes {
                let competitor = self.filteredCompetitors[index.row]
                self.competition.competitors?.add(competitor)
            }
        }
        
        let destinationViewController = segue.destination as! CompetitionViewController
        
        destinationViewController.competition = self.competition
    }
}

extension CompetitorsSelectionViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        
        if textDidChange.isEmpty {
            
            self.filteredCompetitors = self.competitors
            self.tableView.reloadData()
        }
        else {
            self.filterContentForSearchText(textDidChange)
        }
    }
}

extension CompetitorsSelectionViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

