//
//  CompetitionsViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class CompetitionsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    var competitions = [CompetitionMO]()
    var filteredCompetitions = [CompetitionMO]()
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
        
        let allCompetitions = CompetitionsDataService.instance.competitions
        
        self.competitions = allCompetitions.sorted { $0.title! < $1.title! }
        self.filteredCompetitions = self.competitions
    }
    
    var deleteIndexPath: NSIndexPath? = nil
    var competitionToDelete: CompetitionMO? = nil
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteIndexPath = indexPath as NSIndexPath?
            self.competitionToDelete = self.competitions[indexPath.row]
            
            if let competition = self.competitionToDelete {
                confirmDelete(competition: competition)
            }
        }
    }
    
    func confirmDelete(competition: CompetitionMO) {
        let alert = UIAlertController(title: "Delete competition", message: "Are you sure you want permanently delete \(competition.title) ?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteCompetition)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteCompetition)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 1.0, y: 1.0, width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteCompetition(alertAction: UIAlertAction!) -> Void {
        if let indexPath = self.deleteIndexPath {
            
            let competition = self.competitions[indexPath.row]
            
            // Call corresponding data service to delete the item in Core Data
            CompetitionsDataService.instance.delete(competition: competition)
            
            self.filteredCompetitions.remove(at: indexPath.row)
            
            let index = self.competitions.index(of: competition)
            if let index = index {
                self.competitions.remove(at: index)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            self.deleteIndexPath = nil
         }
    }
    
    func cancelDeleteCompetition(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredCompetitions.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let competition = filteredCompetitions[indexPath.row]
        
        cell!.textLabel!.text =
            competition.value(forKey: "title") as? String
        //cell!.detailTextLabel!.text = player.value(forKey: "id") as? String
        
        return cell!
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredCompetitions = self.competitions.filter({( competition : CompetitionMO) -> Bool in
            return (competition.title?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let myctrl = segue.destination as? CompetitionViewController else {
            fatalError("Should not occur")
        }
        
        if let indexpath = tableView.indexPathForSelectedRow {
            myctrl.competition = competitions[indexpath.row]
        }
    }
    
    @IBAction func backCompetition(_ segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
}

extension CompetitionsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        
        if textDidChange.isEmpty {
            
            self.filteredCompetitions = self.competitions
            self.tableView.reloadData()
        }
        else {
            self.filterContentForSearchText(textDidChange)
        }
    }
}

extension CompetitionsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
