//
//  MatchResultViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 14/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class MatchResultViewController: UIViewController {
    
    @IBOutlet weak var competitor1Label: UILabel!
    @IBOutlet weak var competitor2Label: UILabel!
    @IBOutlet weak var competitor1Result: UITextField!
    @IBOutlet weak var competitor2Result: UITextField!
    
    public var match: MatchMO?
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    init(match: MatchMO) {
//        self.match = match
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let match = self.match {
            self.competitor1Label.text = self.competitor1Label.text! + " " + (match.competitor1?.name)!;
            self.competitor2Label.text = self.competitor2Label.text! + " " + (match.competitor2?.name)!;
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveResults(_ sender: Any) {
        self.match?.scoreCompetitor1 = Int16(self.competitor1Result.text!)!
        self.match?.scoreCompetitor2 = Int16(self.competitor2Result.text!)!
        
        self.match?.status = 2
        MatchsDataService.instance.save(match: self.match!)
        
        dismiss(animated: true, completion: nil)
    }
}
