//
//  MatchsViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 04/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation

class PlayersViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var matches = [MatchMO]()
    var filteredMatches = [MatchMO]()
    let searchController = UISearchController(searchResultsController: nil)
    
    public var previousSearchLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allMatches = MatchsDataService.instance.matches
        
        self.matches = allMatches.sorted { $0.id! < $1.id! }
        self.filteredMatches = self.matches
    }
    
    
}
