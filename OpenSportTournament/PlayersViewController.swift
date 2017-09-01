//
//  ViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 22/02/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData

class PlayersViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var players = [PlayerMO]()
    var filteredPlayers = [PlayerMO]()
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

        // (Re)Load all the players in the database
        let allPlayers = PlayersDataService.instance.players
        self.players = allPlayers.sorted { $0.name! < $1.name! }
        
        self.filteredPlayers = self.players
        self.tableView.reloadData()
    }
    
    var deleteIndexPath: NSIndexPath? = nil
    var playerToDelete: PlayerMO? = nil
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIndexPath = indexPath as NSIndexPath?
            playerToDelete = players[indexPath.row]
            
            if let player = playerToDelete {
                confirmDelete(player: player)
            }
        }
    }
    
    func confirmDelete(player: PlayerMO) {
        let alert = UIAlertController(title: "Delete player", message: "Are you sure you want permanently delete \(player.name) ?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlayer)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlayer)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 1.0, y: 1.0, width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlayer(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {

            
            // Get the item to delete before removing it
            if indexPath.row < players.count {
                
                let player = players[indexPath.row]
                PlayersDataService.instance.delete(player: player)
                
                filteredPlayers.remove(at: indexPath.row)
                
                let index = players.index(of: player)
                if let index = index {
                    players.remove(at: index)
                }
                
                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                deleteIndexPath = nil
            }
        }
    }
    
    func cancelDeletePlayer(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
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
        cell?.isEditing = true
        
        
        let player = filteredPlayers[indexPath.row]
        
        cell!.textLabel!.text =
            player.value(forKey: "name") as? String
        //cell!.detailTextLabel!.text = player.value(forKey: "id") as? String
        if player.gender == "Man" {
            cell?.imageView?.image = UIImage(named: "man-2-icon.png")
            //cell?.backgroundColor = UIColor.init(colorLiteralRed: 252/255, green: 148/255, blue: 188/255, alpha: 1.0)
        } else {
            cell?.imageView?.image = UIImage(named: "woman-2-icon.png")
            //cell?.backgroundColor = UIColor.init(colorLiteralRed: 148/255, green: 228/255, blue: 252/255, alpha: 1.0)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    //    return UITableViewCellEditingStyle.delete
    //}
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredPlayers = self.players.filter({( player : PlayerMO) -> Bool in
            return (player.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.destination is PlayerProtocol else {
            fatalError("Should not occur")
        }
        
        var myctrl = segue.destination as! PlayerProtocol
        
        if let indexpath = tableView.indexPathForSelectedRow {
            myctrl.player = players[indexpath.row]
        }
    }
    
//    @IBAction func backPlayer(_ segue: UIStoryboardSegue) {
//        self.tableView.reloadData()
//    }
}

extension PlayersViewController: UISearchBarDelegate {
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

extension PlayersViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
