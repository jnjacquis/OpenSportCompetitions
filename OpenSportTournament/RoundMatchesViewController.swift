//
//  RoundMatchesViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 12/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class RoundMatchesViewController: UIViewController {
    
   
    @IBOutlet weak var roundTitleLabel: UILabel!
    @IBOutlet weak var stackRoundMatches: UIStackView!

    @IBOutlet weak var scrollView: UIScrollView!
    
    public var roundTitle: String?
    public var matches: [MatchMO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(roundTitle)")
        self.roundTitleLabel.text = roundTitle
        
//        var competitor: CompetitorMO = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        
//        let match1: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
//        competitor.name = "Nicolas"
//        match1.competitor1 = competitor
//        competitor.name = "Clément"
//        match1.competitor2 = competitor
//        let matchView1 = MatchView(match: match1, frame: CGRect(x: 10, y: 50, width: 300, height: 150), backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
//        //matchView1.bounds.origin = CGPoint(x: 0, y: 100)
//        self.stackRoundMatches.addArrangedSubview(matchView1)
//        
//        let match2: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
//        match2.competitor1?.name = "Christelle"
//        match2.competitor2?.name = "Frédéric"
//        let matchView2 = MatchView(match: match2, frame: CGRect(x: 10, y: 200, width: 300, height: 150), backgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
//        //matchView2.bounds.origin = CGPoint(x: 0, y: 200)
//        self.stackRoundMatches.addArrangedSubview(matchView2)
//        
//        let match3: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
//        match3.competitor1?.name = "Moi"
//        match3.competitor2?.name = "Toi"
//        let matchView3 = MatchView(match: match3, frame: CGRect(x: 10, y: 350, width: 300, height: 150), backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
//        //matchView3.bounds.origin = CGPoint(x: 0, y: 300)
//        self.stackRoundMatches.addArrangedSubview(matchView3)
//        
//        let match4: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
//        match4.competitor1?.name = "Jean-Charles"
//        match4.competitor2?.name = "Jean-Noel"
//        let matchView4 = MatchView(match: match4, backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
//        //matchView3.bounds.origin = CGPoint(x: 0, y: 300)
//        self.stackRoundMatches.addArrangedSubview(matchView4)
        
        for match in self.matches! {
            let matchView = MatchView(match: match, frame: CGRect(x: 0, y: 0, width: self.stackRoundMatches.bounds.size.width, height: 100), backgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            self.stackRoundMatches.addArrangedSubview(matchView)
        }
        
        print(self.stackRoundMatches.bounds.size)
        self.scrollView.contentSize = self.stackRoundMatches.bounds.size
    }
}
