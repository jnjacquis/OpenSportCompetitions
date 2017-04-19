//
//  TeamViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 21/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import Foundation

class TeamViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var teamName: UITextField!

    @IBOutlet weak var teamMembers: UITableView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    public var team: TeamMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let team = try self.team {
            self.teamName.text = team.name
            
            self.teamMembers.dataSource = self
            self.teamMembers.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.teamMembers.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return (self.team.members?.count)!
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let members: [PlayerMO] = self.team.members?.allObjects as! [PlayerMO]
        let member = members[indexPath.row]
        
        cell!.textLabel!.text =
            member.value(forKey: "name") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            if let member = self.team.members?[indexPath.row] {
//
//                
//                // Save this change for the team in Core Date
//                TeamsDataService.instance.save(team: self.team)
//                
//                // Update the table view of members
//                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
//            }
//        }
        if editingStyle == .delete {
            guard let members = self.team.members else {
                return
            }
            
            let allMembers = members.allObjects as! [PlayerMO]
            let selectedMember = allMembers[indexPath.row]
            
            // Remove the selected member from its parent ie team
            self.team.members?.remove(selectedMember)
            
            // Update the table view of members
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("Cancel team edition")
    }
    
    @IBAction func saveTeam(_ sender: Any) {
        print("Save team")
    }
    
    @IBAction func didMembersSelection(_ segue: UIStoryboardSegue) {
        self.teamMembers.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let button = sender as! UIBarButtonItem
//        print(button.title)
        
//        if self.team == nil {
//            // Create instance of entity and set its properties from the view fields
//            self.team = TeamMO(entity: TeamsDataService.instance.entity,
//                                   insertInto: TeamsDataService.instance.managedContext)
//            self.team.name = self.teamName.text!;
//            self.team.members = NSMutableOrderedSet()
//        }
//        
//        let segueId = segue.identifier
//        print(segueId)
//        
//        let dest = segue.destination as! TeamsViewController
//        print(dest)
//        
        if segue.identifier == "showMemberSelection" {
            
            if let navigationController = segue.destination as? UINavigationController {
                
                if let controller = navigationController.topViewController as? MembersSelectionViewController {
                    if self.team == nil {
                        self.team = TeamMO(entity: TeamsDataService.instance.entity, insertInto: TeamsDataService.instance.managedContext)
                    }
                    
                    controller.team = self.team
                }
            }
        } else {

            guard let button: UIBarButtonItem = sender as! UIBarButtonItem, button.title == "Save" else {
                return
            }
            
            self.team.name = self.teamName.text!
            
            // Save instance team in any case
            TeamsDataService.instance.save(team: self.team)
            
            let destinationController = segue.destination as! TeamsViewController
            
            if !destinationController.teams.contains(self.team) {
                destinationController.teams.append(self.team)
                destinationController.filteredTeams.append(self.team)
            }
            else {
                destinationController.teams.index(of: <#T##TeamMO#>)
            }
        }
    }
}
