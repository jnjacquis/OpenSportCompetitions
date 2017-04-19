//
//  TeamsViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class TeamsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var teams = [TeamMO]()
    var filteredTeams = [TeamMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var previousSearchLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allTeams = TeamsDataService.instance.teams
        
        self.teams = allTeams.sorted {
            guard let name0 = $0.name else {
                return false
            }
            
            guard let name1 = $1.name else {
                return false
            }
        
            return name0 < name1
        }
        self.filteredTeams = self.teams
    }
    
    
    var deleteIndexPath: NSIndexPath? = nil
    var teamToDelete: TeamMO? = nil
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIndexPath = indexPath as NSIndexPath?
            teamToDelete = teams[indexPath.row]
            
            if let team = teamToDelete {
                confirmDelete(team: team)
            }
        }
    }
    
    func confirmDelete(team: TeamMO) {
        let alert = UIAlertController(title: "Delete team", message: "Are you sure you want permanently delete \(team.name) ?", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive, handler: handleConfirm)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: handleCancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 1.0, y: 1.0, width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleConfirm(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {
            
            let team = teams[indexPath.row]
            TeamsDataService.instance.delete(team: team)
            
            self.filteredTeams.remove(at: indexPath.row)
            
            let index = self.teams.index(of: team)
            if let index = index {
                self.teams.remove(at: index)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteIndexPath = nil
        }
    }

    func handleCancel(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredTeams.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let team = filteredTeams[indexPath.row]
        
        cell!.textLabel!.text =
            team.value(forKey: "name") as? String
        cell!.imageView?.image = UIImage(named: "Group-icon.png")
        
        return cell!
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredTeams = self.teams.filter({( player : TeamMO) -> Bool in
            return (player.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    @IBAction func backTeam(_ segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let myctrl = segue.destination as? TeamViewController else {
            fatalError("Should not occur")
        }
        
        if let indexpath = tableView.indexPathForSelectedRow {
            myctrl.team = teams[indexpath.row]
        }
    }
}

extension TeamsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        
        if textDidChange.isEmpty {
            
            self.filteredTeams = self.teams
            self.tableView.reloadData()
        }
        else {
            self.filterContentForSearchText(textDidChange)
        }
    }
}

extension TeamsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

