//
//  NewCompetitionStage.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 02/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class NewCompetitionStage: UIViewController {
    
    public var competition: CompetitionMO!
    
    @IBAction func newSingleEliminationStage(_ sender: Any) {
        let newStage: CompetitionStageMO = newCompetitionStage(0)!
        competition.stages?.add(newStage)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func newPoolStage(_ sender: Any) {
        let newStage: CompetitionStageMO = newCompetitionStage(1)!
        competition.stages?.add(newStage)
        self.navigationController?.popViewController(animated: false)
    }
    
    private func newCompetitionStage(_ type: UInt8) -> CompetitionStageMO? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CompetitionStage", in: managedContext)!
        
        // Create instance of entity and set its properties from the view fields
        let stage = CompetitionStageMO(entity: entity, insertInto: managedContext)
        
        stage.type = Int16(type)
        stage.competition = self.competition
        
        if let stages = self.competition.stages?.allObjects {
            let previousStage: CompetitionStageMO = stages.last as! CompetitionStageMO
            // Last one plus 1
            stage.id = Int16(previousStage.id + 1)
        } else {
            stage.id = 1 // First stage index, start from 1
        }
        //stage.id = 1
        
        return stage
    }
}
