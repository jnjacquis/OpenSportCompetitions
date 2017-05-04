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
    
    @IBOutlet weak var newSingleEliminationStage: UIButton!
    @IBOutlet weak var newPoolStage: UIButton!
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let source = sender else {
            return
        }
        
        let button = source as! UIButton
        
        if self.competition.stages == nil {
            self.competition.stages = NSMutableSet()
        }
        
        if button == self.newSingleEliminationStage {
            competition.stages?.add(newCompetitionStage(0))
        } else {
            competition.stages?.add(newCompetitionStage(1))
        }
        
        let destination = segue.destination as! CompetitionViewController
        destination.competition = self.competition
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
        stage.competitionId = self.competition
        
        if let stages = self.competition.stages {
            stage.id = stages.count + 1   // Last one plus 1
        } else {
            stage.id = 1 // First stage index, start from 1
        }
        
        return stage
    }
}
