//
//  PlayerViewController.swift
//  OpenSportTournament
//
//  Created by Jean-Noel on 25/02/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerSex: UISegmentedControl!
    @IBOutlet weak var playerBirthdate: UIDatePicker!
    @IBOutlet weak var playerRanking: UITextField!
    
    public var player: PlayerMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let playr = try self.player {
            self.playerName.text = playr.name;
            
            if playr.gender == "Man" {
                self.playerSex.selectedSegmentIndex = 0
                
            } else {
                self.playerSex.selectedSegmentIndex = 1
                
            }
            
            if let birthday = playr.birthday {
                self.playerBirthdate.date = birthday as Date;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPlayer(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePlayer(_ sender: Any) {
    
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if self.player == nil {
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Player",
                                                    in: managedContext)!
            // Create instance of entity and set its properties from the view fields
            self.player = PlayerMO(entity: entity,
                                  insertInto: managedContext)
        }

        self.player.name = self.playerName.text!;
        self.player.gender = self.playerSex.titleForSegment(at: self.playerSex.selectedSegmentIndex);
        self.player.birthday = self.playerBirthdate.date as NSDate;
        
        PlayersDataService.instance.save(player: player)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if self.player == nil {
            // Create instance of entity and set its properties from the view fields
            self.player = PlayerMO(entity: PlayersDataService.instance.entity,
                                   insertInto: PlayersDataService.instance.managedContext)
        }
        
        self.player.name = self.playerName.text!;
        if self.playerSex.selectedSegmentIndex == 0 {
            self.player.gender = "Man"
        } else {
            self.player.gender = "Woman"
        }
        self.player.birthday = self.playerBirthdate.date as NSDate;
        
        // Save instance player in any case
        PlayersDataService.instance.save(player: player)
        
        let destinationController = segue.destination as! PlayersViewController
        
        if !destinationController.players.contains(self.player) {
            destinationController.players.append(self.player)
            destinationController.filteredPlayers.append(self.player)
        }
        else {
            if let playerIndex = destinationController.players.index(of: self.player) {
                destinationController.players[playerIndex] = self.player
                destinationController.filteredPlayers[playerIndex] = self.player
            }
        }
    }
}
