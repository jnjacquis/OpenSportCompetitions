//
//  MembersSelectionViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 06/04/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class MembersSelectionViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var team: TeamMO!
    
    var players = [PlayerMO]()
    var filteredPlayers = [PlayerMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var previousSearchLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar.delegate = self
        
        self.tableView.setEditing(true, animated: false)
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allPlayers = PlayersDataService.instance.players
        
        self.players = allPlayers.sorted { $0.name! < $1.name! }
        self.filteredPlayers = self.players
        
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredPlayers.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let player = filteredPlayers[indexPath.row]
        
        
        cell!.textLabel!.text =
            player.value(forKey: "name") as? String

        if (self.team.members?.contains(player))! {
             self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
        
        return cell!
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredPlayers = self.players.filter({( player : PlayerMO) -> Bool in
            return (player.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    @IBAction func cancel() {
//        //dismiss(animated: false, completion: nil)
//        let storyboard = UIStoryboard(name: "Teams", bundle: nil)
//        let teamEditViewController = storyboard.instantiateViewController(withIdentifier: "teamEditViewController") as! TeamEditViewController
//        self.present(teamEditViewController, animated: false, completion: nil)
//        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveMembers() {
        // Remove all members from the current team, even if no members are selected in the table view
        self.team.members?.removeAllObjects()
        
        if let indexes = self.tableView.indexPathsForSelectedRows {
            
            for index in indexes {
                let player = self.filteredPlayers[index.row]
                self.team.members?.add(player)
            }
        }

        if let teamEditVC = self.navigationController?.viewControllers[2] as? TeamEditViewController {
            teamEditVC.team = self.team
        }
        
        self.navigationController?.popViewController(animated: false)
    }
}

extension MembersSelectionViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        
        if textDidChange.isEmpty {
            
            self.filteredPlayers = self.players
            self.tableView.reloadData()
        }
        else {
            self.filterContentForSearchText(textDidChange)
        }
    }
}

extension MembersSelectionViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


