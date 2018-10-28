//
//  TeamScoreViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/26/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit

class TeamScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var lblScoreEvent: UILabel!
    @IBOutlet weak var lblScoreOpp: UILabel!
    @IBOutlet weak var lblScoreValue: UILabel!
    
}

class TeamScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblTeamScores: UITableView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTeamRecord: UILabel!
    
    
    var testScoreTexts = [
        ["Varsity Volleyball", "10/2/2018", "6:30 PM", "away", "Taft", "loss", "2-3"],
        ["Varsity Volleyball", "10/6/2018", "6:30 PM", "away", "Sacred Heart", "win", "3-1"],
        ["Varsity Volleyball", "10/10/2018", "6:30 PM", "away", "Choate", "win", "3-0"],
        ["Varsity Volleyball", "10/13/2018", "6:30 PM", "away", "Loomis", "loss", "0-3"],
        ["Varsity Volleyball", "10/17/2018", "4:00 PM", "home", "Deerfield", "loss", "0-3"],
        ["Varsity Volleyball", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
    ]
    
    var myScoreItems = [ScoreItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTeamScores.dataSource = self
        tblTeamScores.delegate = self
        
        tblTeamScores.rowHeight = 60.0
        
        // Do any additional setup after loading the view.
        
        loadTestScores()
        updateLabels()
        
//        filterScores()
        
        //        print(filteredScores)
        
    }
    
    func loadTestScores() {
        for scoreText in testScoreTexts {
            print(scoreText)
            
            //        let scoreText = testScoreTexts[0]
            //        print(scoreText)
            
            let team = scoreText[0]
            
            let date = scoreText[1]
            let dateParts = date.split(separator: "/")
            let month = Int(dateParts[0])!
            let day = Int(dateParts[1])!
            let year = Int(dateParts[2])!
            //            print(dateParts)
            
            let time = scoreText[2]
            let timeParts = time.split(separator: " ")
            let timeNumParts = timeParts[0].split(separator: ":")
            var hour = Int(timeNumParts[0])!
            let mins = Int(timeNumParts[1])!
            let AMPM = timeParts[1]
            if AMPM == "PM" {
                hour += 12
            }
            
            //            print(timeParts)
            //            print(timeNumParts)
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = mins
            //            print(dateComponents)
            
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
            //            print(scoreItem)
            
            myScoreItems.append(scoreItem)
        }
        
        //print(myScoreItems)
    }
    
    func updateLabels() {
        if myScoreItems.count > 0 {
            let teamName = myScoreItems[0].myScoreTeam.myTeamName
            
            lblTeamName.text = teamName


            
            var record = TeamRecordItem(myRecordTeam: Team(myTeamName: teamName), myRecordWins: 0, myRecordLosses: 0, myRecordTies: 0)
            
            for scores in myScoreItems {
                switch scores.myScoreResult {
                case .win: record.myRecordWins += 1
                case .lose: record.myRecordLosses += 1
                case .tie: record.myRecordTies += 1
                default: break
                }
            }
            
            let recordStr = record.shortRecord
            
            lblTeamRecord.text = "Overall Record: \(recordStr)"
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
        return myScoreItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableItemScore", for: indexPath) as! ScoreTableViewCell
        
        // Configure the cell...
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 15/255, green: 43/255, blue: 91/255, alpha: 0.4)
        } else {
            cell.backgroundColor = .white
        }
        
        let scoreItem = myScoreItems[indexPath.row]
        
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
        
        cell.lblScoreEvent.text = "\(date) \(team)"
        cell.lblScoreOpp.text = locText
        cell.lblScoreValue.text = result
        
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
//    }
    
}
