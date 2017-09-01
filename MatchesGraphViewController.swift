//
//  MatchesGraphViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 23/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class MatchesGraphViewController: UIViewController {
    
    private var match: MatchMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.match = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
    }
}
