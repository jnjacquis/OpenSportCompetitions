//
//  TeamViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 29/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import Foundation

class TeamViewController: UIViewController, UITableViewDataSource, TeamProtocol {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var teamMembers: UITableView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    public var team: TeamMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamImage.image = #imageLiteral(resourceName: "Group-icon-2")
        
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
        
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var myctrl = segue.destination as! TeamProtocol
        myctrl.team = self.team
    }
}

