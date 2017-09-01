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
import CoreGraphics

class PlayerEditViewController: UIViewController, PlayerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerSex: UISegmentedControl!
    @IBOutlet weak var playerBirthdate: UIDatePicker!
    @IBOutlet weak var playerRanking: UITextField!
    @IBOutlet weak var playerImage: UIImageView!
    
    public var player: PlayerMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerImage.image = #imageLiteral(resourceName: "man-2-icon-2")
        
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage {
            var newImage: UIImage? = nil
            
            // Get the device current orientation and crop original image/photo to a square
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                let newWidth = image.size.height
                let crop = CGRect(x: (image.size.width - newWidth)/2, y: 0, width: newWidth, height: image.size.height)
                let cgImage = image.cgImage!.cropping(to: crop)
                newImage = UIImage(cgImage: cgImage!)
                break
            case .portrait, .portraitUpsideDown:
                let newHeight = image.size.width
                let crop = CGRect(x: 0, y: (image.size.height - newHeight)/2, width: image.size.width, height: newHeight)
                let cgImage = image.cgImage!.cropping(to: crop)
                newImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
                break
            default:
                newImage = image
            }
            
            playerImage.image = newImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPlayer(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
        
        if let playerImage = self.playerImage.image {
            let playerPhoto: Data? = UIImagePNGRepresentation(playerImage)
        
            if let data = playerPhoto {
                self.player.photo = NSData(data: data)
            }
        }
        
        // Save instance player in any case
        PlayersDataService.instance.save(player: player)
        
//        let storyboard = UIStoryboard.init(name: "Players", bundle: nil)
//        let players: UIViewController = storyboard.instantiateViewController(withIdentifier: "Players")
//        
//        if players is PlayersViewController {
//            let playersVC = players as! PlayersViewController
            //playersVC.addPlayerToTable(player: self.player)
//        }
        
        self.navigationController?.popViewController(animated: false)
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
