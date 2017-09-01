//
//  CompetitionGraphViewController.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 30/05/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation
import UIKit

class CompetitionGraphViewController: UIPageViewController {
    var roundMatchesVC: [UIViewController] = []
    let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 50, width: 50, height: 20))
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newRoundMatchesViewController(title: "8th round", numberOfRounds: 3),
                self.newRoundMatchesViewController(title: "Quarter-finals", numberOfRounds: 2),
                self.newRoundMatchesViewController(title: "Semi-finals", numberOfRounds: 1),
                self.newRoundMatchesViewController(title: "Final", numberOfRounds: 0)]
    }()
    
    private func newRoundMatchesViewController(title: String, numberOfRounds: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "RoundMatches", bundle: nil)
        let newViewController: RoundMatchesViewController = storyboard.instantiateViewController(withIdentifier: "roundMatches") as! RoundMatchesViewController
        newViewController.roundTitle = title
        
        let numberOfMatches: Int = Int(pow(2.0, Float(numberOfRounds)))
        print("Matches of the round: #\(numberOfMatches)")
        
        var matches: [MatchMO] = [MatchMO]()
        
        for _ in 1...numberOfMatches {
            let match: MatchMO = MatchMO(entity: MatchsDataService.entity, insertInto: MatchsDataService.managedContext)
            
            //if matchIndex == numberOfMatches {
                let competitor1 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
                competitor1.name = "Me"
                match.competitor1 = competitor1
                
                let competitor2 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
                competitor2.name = "You"
                match.competitor2 = competitor2
            //}
            
            matches.append(match)
        }
        
        newViewController.matches = matches
        
        return newViewController
    }
    
    var currentIndex:Int {
        get {
            return orderedViewControllers.index(of: self.viewControllers!.first!)!
        }
        
        set {
            guard newValue >= 0,
                newValue < orderedViewControllers.count else {
                    return
            }
            
            let vc = orderedViewControllers[newValue]
            let direction:UIPageViewControllerNavigationDirection = newValue > currentIndex ? .forward : .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self as? UIPageViewControllerDataSource
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        //let pageControlConstraints: NSLayoutConstraint = NSLayoutConstraint(
        
        pageControl.numberOfPages = orderedViewControllers.count
        self.view.addSubview(pageControl)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataSource = self
//        
//        let competition = CompetitionMO(entity: CompetitionsDataService.instance.entity, insertInto: CompetitionsDataService.instance.managedContext)
//        let competitor1 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor1.name = "Nicolas"
//        competition.addToCompetitors(competitor1)
//        
//        let competitor2 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor2.name = "Clément"
//        competition.addToCompetitors(competitor2)
//        
//        let competitor3 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor3.name = "Christelle"
//        competition.addToCompetitors(competitor3)
//        
//        let competitor4 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor4.name = "Jean-Noel"
//        competition.addToCompetitors(competitor4)
//      
//        let competitor5 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor5.name = "Boris"
//        competition.addToCompetitors(competitor5)
//        
//        let competitor6 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor6.name = "Mélanie"
//        competition.addToCompetitors(competitor6)
//        
//        let competitor7 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor7.name = "Elora"
//        competition.addToCompetitors(competitor7)
//        
//        let competitor8 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor8.name = "Eric"
//        competition.addToCompetitors(competitor8)
//        
//        let competitor9 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor9.name = "Anne"
//        competition.addToCompetitors(competitor9)
//        
//        let competitor10 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor10.name = "Loraine"
//        competition.addToCompetitors(competitor10)
//        
//        let competitor11 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor11.name = "Gabriel"
//        competition.addToCompetitors(competitor11)
//        
//        let competitor12 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor12.name = "Lucie"
//        competition.addToCompetitors(competitor12)
//        
//        let competitor13 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor13.name = "Clément B."
//        competition.addToCompetitors(competitor13)
//        
//        let competitor14 = CompetitorMO(entity: PlayersDataService.instance.entity, insertInto: PlayersDataService.instance.managedContext)
//        competitor14.name = "Jean-Charles"
//        competition.addToCompetitors(competitor14)
//        
//        let stage = CompetitionStageMO(entity: CompetitionStagesDataService.instance.entity, insertInto: CompetitionStagesDataService.instance.managedContext)
//        stage.active = true
//        stage.competition = competition
//        stage.competitors = competition.competitors
//        competition.stages?.add(stage)
//        
//        
//        let storyboard = UIStoryboard(name: "RoundMatches", bundle: nil)
//        let roundMatchesViewControllerQuarterFinals = storyboard.instantiateViewController(withIdentifier: "roundMatches") as! RoundMatchesViewController
//        roundMatchesViewControllerQuarterFinals.roundTitle.text = "Quarter-finals"
//        self.roundMatchesVC.append(roundMatchesViewControllerQuarterFinals)
//        
//        let roundMatchesViewControllerSemiFinals = storyboard.instantiateViewController(withIdentifier: "roundMatches") as! RoundMatchesViewController
//        roundMatchesViewControllerSemiFinals.roundTitle.text = "Semi-finals"
//        self.roundMatchesVC.append(roundMatchesViewControllerSemiFinals)
//        
//        let roundMatchesViewControllerFinal = storyboard.instantiateViewController(withIdentifier: "roundMatches") as! RoundMatchesViewController
//        roundMatchesViewControllerFinal.roundTitle.text = "Final"
//        self.roundMatchesVC.append(roundMatchesViewControllerFinal)
//        
//        
//        let result: (Node<MatchMO>, Int) = PoolGenerator.computeMatches(stage)!
//        let rootMatch = result.0
//        let levelsCount: Int = result.1 - 1
//
//        var level = levelsCount
//        
//        let width = Int(self.view.bounds.width)
//        let backgroundColors = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) ]
//        
//        //self.stackView.distribution = .equalSpacing
//        
//        //var overallTreeFrame = CGRect(x: 0, y: 0, width: width, height: 100)
//        
//        for index in 1...1 {
//            // Compute the frame rect according to the index from left to right
//            let index1 = index + 1
//            print(index1)
//            let powerOf2: Decimal = pow(2.0, index)
//            let power = NSDecimalNumber(decimal: powerOf2)
//            let powerInt = Int(power)
//            print("Square of 2: \(powerInt)")
//            
//            // Frame for the match view is full width of the screen
//            //var matchFrame:CGRect = CGRect(x: index * width, y: 0, width: width, height: powerInt * 100)
//            //var matchFrame: CGRect = CGRect(x: 10, y: 100, width: 300, height: 100)
//            
////            if overallTreeFrame.size.width < (matchFrame.origin.x + 100) {
////                overallTreeFrame.size.width = matchFrame.origin.x + 100
////            }
//            
//            let matches: [MatchMO] = PoolGenerator.elements(at: 1, root: rootMatch)
//            print("Matches for level \(level): #\(matches.count)")
//            
//            for match in matches {
//                print(match)
//                
//                // Create a new view for the current match and add it to the stack view
//                let _ = MatchView(match: match, backgroundColor: backgroundColors[0])
//                //self.stackView.addArrangedSubview(mv)
//                
//                // Update match frame for the next one
//                //matchFrame = CGRect(x: matchFrame.origin.x, y: matchFrame.origin.y + matchFrame.size.height, width: CGFloat(width), height: matchFrame.size.height)
//            }
////
////            
////            self.view.addSubview(MatchView(match: matches[0], backgroundColor: backgroundColors[0]))
////            self.view.addSubview(MatchView(match: matches[1], backgroundColor: backgroundColors[1]))
////            self.view.addSubview(MatchView(match: matches[2], backgroundColor: backgroundColors[2]))
////            
//            
//            
//            level -= 1
//            
//            self.setViewControllers([roundMatchesViewControllerQuarterFinals, roundMatchesViewControllerSemiFinals, roundMatchesViewControllerFinal], direction: .forward, animated: true, completion: nil)
//            
//            // Update the overall tree frame
////            if overallTreeFrame.size.height < (matchFrame.size.height + 100) {
////                overallTreeFrame.size.height = matchFrame.size.height + 100
////            }
//        }
//        
//        // Update the scrollview content size
//        //self.scrollView.contentSize = overallTreeFrame.size
//        
//    }
}

// MARK: UIPageViewControllerDataSource

extension CompetitionGraphViewController:UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        //self.pageControl.currentPage = previousIndex
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        //self.pageControl.currentPage = nextIndex
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return currentIndex
    }
}

extension CompetitionGraphViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                                     didFinishAnimating finished: Bool,
                                     previousViewControllers: [UIViewController],
                                     transitionCompleted completed: Bool) {
//        let previousViewController = previousViewControllers[0]
//        
//        guard let viewControllerIndex = orderedViewControllers.index(of: previousViewController) else {
//            return
//        }
//

        if (!completed) {
            return
        }
        
        self.pageControl.currentPage = currentIndex
        //self.pageControl.setNeedsDisplay()
    }
}
