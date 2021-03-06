//
//  TeamEditViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 21/03/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TeamEditViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TeamProtocol {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UITextField!

    @IBOutlet weak var teamMembers: UITableView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    public var team: TeamMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamImage.image = #imageLiteral(resourceName: "Group-icon-2")

        if self.team == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Team",
                                                    in: managedContext)!
            // Create instance of entity and set its properties from the view fields
            self.team = TeamMO(entity: entity,
                               insertInto: managedContext)
        }
        
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
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
        }
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] {
            teamImage.image = image as? UIImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveTeam(_ sender: Any) {


        
        self.team.name = self.teamName.text
        
        if let teamImage = self.teamImage.image {
            let teamPhoto: Data? = UIImagePNGRepresentation(teamImage)
            
            if let data = teamPhoto {
                self.team.photo = NSData(data: data)
            }
        }
        
        // Save instance team in any case
        TeamsDataService.instance.save(team: self.team)
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func didMembersSelection(_ segue: UIStoryboardSegue) {
        self.teamMembers.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if self.team == nil {
            self.team = TeamMO(entity: TeamsDataService.instance.entity, insertInto: TeamsDataService.instance.managedContext)
        }
        
        if segue.identifier == "showMemberSelection" {
            
            //if let navigationController = segue.destination as? UINavigationController {
                
                if let controller = segue.destination as? MembersSelectionViewController {
                    controller.team = self.team
                }
            //}
        } else {

            guard let button: UIBarButtonItem = sender as! UIBarButtonItem, (button.title != "Cancel" && button.title != "Abandonner") else {
                return
            }
            
            self.team.name = self.teamName.text!
            let teamPhoto: Data? = UIImagePNGRepresentation(self.teamImage.image!)
            if let data = teamPhoto {
                self.team.photo = NSData(data: data)
            }
            
            // Save instance team in any case
            TeamsDataService.instance.save(team: self.team)
            
            let destinationController = segue.destination as! TeamsViewController

            if !destinationController.teams.contains(self.team) {
                destinationController.teams.append(self.team)
                destinationController.filteredTeams.append(self.team)
            }
            else {
                if let teamIndex = destinationController.teams.index(of: self.team) {
                    destinationController.teams[teamIndex] = self.team
                    destinationController.filteredTeams[teamIndex] = self.team
                }
            }
        }
    }
}

