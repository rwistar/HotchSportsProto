//
//  ScoreViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/17/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit
import UserNotifications

class ScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var lblScoreDate: UILabel!
    @IBOutlet weak var lblScoreTeam: UILabel!
    @IBOutlet weak var lblScoreOpp: UILabel!
    @IBOutlet weak var lblScoreValue: UILabel!
    
}

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ScoreFilterDelegate {
    
    @IBOutlet weak var tblScores: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var timer = Timer()
    
    var testScoreTexts = [
        ["Varsity Volleyball", "10/17/2018", "4:00 PM", "home", "Deerfield", "loss", "0-3"],
        ["Boys Varsity Water Polo", "10/17/2018", "3:00 PM", "home", "Loomis", "loss", "9-14"],
        ["Varsity Volleyball", "10/13/2018", "6:30 PM", "away", "Loomis", "loss", "0-3"],
        ["Boys Varsity Soccer", "10/13/2018", "3:30 PM", "away", "Deerfield", "loss", "0-4"],
        ["Boys Varsity Water Polo", "10/13/2018", "3:30 PM", "away", "Deerfield", "loss", "10-14"],
        ["Girls Varsity Soccer", "10/19/2018", "6:30 PM", "home", "Choate", "future", ""],
        ["Varsity Field Hockey", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
        ["Varsity Volleyball", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
        ["Boys Varsity Soccer", "10/20/2018", "2:00 PM", "home", "Choate", "future", ""],
        
        ]
    
    var myScoreTeams: [String : Bool] = [
        "Boys Cross Country": true,
        "Girls Cross Country": true,
        "Field Hockey": true,
        "Mountain Biking": true,
        "Football": true,
        "Boys Soccer": true,
        "Girls Soccer": true,
        "Volleyball": true,
        "Water Polo": true
    ]
    
    var filteredScores = [ScoreItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblScores.dataSource = self
        tblScores.delegate = self
        
        tblScores.rowHeight = 60.0
                
        // Do any additional setup after loading the view.
        
        loadTestScores()
        filterScores()
        
        if #available(iOS 10.0, *) {
            tblScores.refreshControl = refreshControl
        } else {
            tblScores.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refreshScores(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Scores")
        
    }
    
    @objc
    private func refreshScores(_ sender: Any) {
        print("refresh called")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.stopRefresh), userInfo: nil, repeats: false)
    }
    
    @objc
    func stopRefresh() {
        myScoreItems[5].myScoreResult = .tie
        myScoreItems[5].myScoreText = "1-1"
        
        myScoreItems[6].myScoreResult = .win
        myScoreItems[6].myScoreText = "2-0"
        
        myScoreItems[7].myScoreResult = .lose
        myScoreItems[7].myScoreText = "2-3"
        
        filterScores()
        tblScores.reloadData()

        refreshControl.endRefreshing()
    }

    func loadTestScores() {
        for scoreText in testScoreTexts {
            print(scoreText)
            
            let team = scoreText[0]
            
            let date = scoreText[1]
            let dateParts = date.split(separator: "/")
            let month = Int(dateParts[0])!
            let day = Int(dateParts[1])!
            let year = Int(dateParts[2])!
            
            let time = scoreText[2]
            let timeParts = time.split(separator: " ")
            let timeNumParts = timeParts[0].split(separator: ":")
            var hour = Int(timeNumParts[0])!
            let mins = Int(timeNumParts[1])!
            let AMPM = timeParts[1]
            if AMPM == "PM" {
                hour += 12
            }
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = mins
            
            var loc: ScoreItem.Location = .other
            switch scoreText[3] {
            case "home": loc = .home
            case "away": loc = .away
            default: loc = .other
            }
            
            let opp = scoreText[4]
            
            var result: ScoreItem.GameResult = .other
            switch scoreText[5] {
            case "win": result = .win
            case "loss": result = .lose
            case "tie": result = .tie
            case "cancel": result = .cancel
            case "future": result = .future
            default: result = .other
            }
            
            let score = scoreText[6]
            
            let scoreItem = ScoreItem(myScoreTeam: Team(myTeamName: team), myScoreDate: dateComponents, myScoreLoc: loc, myScoreOpp: Opponent(myOppName: opp), myScoreResult: result, myScoreText: score)
            
            myScoreItems.append(scoreItem)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableItemScore", for: indexPath) as! ScoreTableViewCell
        
        // Configure the cell...
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 15/255, green: 43/255, blue: 91/255, alpha: 0.2)
        } else {
            cell.backgroundColor = .white
        }
        
        let scoreItem = filteredScores[indexPath.row]
        
        let date = scoreItem.shortDate
        
        let team = scoreItem.myScoreTeam
        
        let loc = scoreItem.myScoreLoc
        var locText = ""
        switch loc {
        case .away: locText = "@ "
        case .home: locText = "vs. "
        default: locText = ""
        }
        locText += scoreItem.myScoreOpp.myOppName
        
        var result = ""
        if scoreItem.myScoreResult == .future {
            result = scoreItem.shortTime
        } else {
            result = scoreItem.shortResult
        }
        
        cell.lblScoreDate.text = date
        cell.lblScoreTeam.text = team.description
        cell.lblScoreOpp.text = locText
        cell.lblScoreValue.text = result
        
        return cell
    }
    
    /// update filteredScores to include only selected teams from myScoreTeams
    func filterScores() {
        filteredScores = [ScoreItem]()
        
        for scoreItem in myScoreItems {
            for team in myScoreTeams.keys {
                if myScoreTeams[team] == true && scoreItemMatch(team: scoreItem.myScoreTeam.myTeamName, key: team) {
                    filteredScores.append(scoreItem)
                }
            }
        }
    }
    
    /// checks to see if a given team matches a generic program name (e.g., does "Boys JV Soccer" contain "Boys Soccer"? --> TRUE)
    ///
    /// - Parameters:
    ///   - team: the team to check
    ///   - key: the sport to search for
    /// - Returns: true if team contains key, else false
    func scoreItemMatch(team: String, key: String) -> Bool {
        let teamWords = key.split(separator: " ")
        var wordArray = [String]()
        for word in teamWords {
            wordArray.append(String(word))
        }

        for word in wordArray {
            if !team.contains(word) {
                return false
            }
        }
        
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueScoreFilter" {
            if let destination = segue.destination as? ScoreFilterTableViewController {
                destination.teamFlags = myScoreTeams
                
                destination.tableView.reloadData()
                
                destination.delegate = self
            }
            
        } else if segue.identifier == "segueScoresToTeam" {
            if let destination = segue.destination as? TeamScoreViewController {
                let cell = sender as! ScoreTableViewCell
                
                let team = cell.lblScoreTeam.text
                
                destination.teamName = team
            }
        }
    }
    
    /// Delegate method to update myScoreTeams from filter page
    ///
    /// - Parameter teamFlags: new values for myScoreTeams
    func updateScoreTable(teamFlags: [String : Bool]) {
        print("\n\n\nUPDATE_SCORE_TABLE")
        
        myScoreTeams = teamFlags
        
        filterScores()

        tblScores.reloadData()
    }
    
}
