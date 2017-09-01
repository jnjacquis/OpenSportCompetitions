//
//  PlayerViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 28/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreGraphics

class PlayerViewController: UIViewController, PlayerProtocol {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerSex: UISegmentedControl!
    @IBOutlet weak var playerBirthdate: UILabel!
    @IBOutlet weak var playerRanking: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.locale = Locale.current
                self.playerBirthdate.text = dateFormatter.string(from: birthday as Date);
            }
            
            if let image = playr.photo {
                let photoData: Data = player.photo as! Data
                playerImage.image = UIImage(data: photoData)
            }
            else {
                if playr.gender == "Man" {
                    playerImage.image = #imageLiteral(resourceName: "man-2-icon-2")
                }
                else {
                    playerImage.image = #imageLiteral(resourceName: "woman-2-icon-2")
                }
            }
            
            self.playerRanking.text = playr.ranking
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//        guard segue.destination is PlayerProtocol else {
//            fatalError("Should not occur")
//        }

        var myctrl = segue.destination as! PlayerProtocol
        myctrl.player = self.player
    }
}


