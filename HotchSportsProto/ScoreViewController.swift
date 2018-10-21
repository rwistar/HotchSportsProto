//
//  ScoreViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/17/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var lblScoreEvent: UILabel!
    @IBOutlet weak var lblScoreOpp: UILabel!
    @IBOutlet weak var lblScoreValue: UILabel!
    
}

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var tblScores: UITableView!
    
    var testScoreTexts = [
        ["Varsity Volleyball", "10/17/2018", "4:00 PM", "home", "Deerfield", "loss", "0-3"],
        ["JV Volleyball", "10/17/2018", "4:00 PM", "home", "Deerfield", "win", "3-1"],
        ["Girls Thirds Soccer", "10/17/2018", "3:00 PM", "home", "Westminster", "win", "4-0"],
        ["Boys Varsity Water Polo", "10/17/2018", "3:00 PM", "home", "Loomis", "loss", "9-14"],
        ["Boys JV Soccer", "10/17/2018", "2:30 PM", "away", "Salisbury", "win", "5-1"],
        ["Thirds Volleyball", "10/17/2018", "2:30 PM", "away", "Taft", "win", "3-0"],
        ["Varsity Volleyball", "10/13/2018", "6:30 PM", "away", "Loomis", "loss", "0-3"],
        ["JV Volleyball", "10/13/2018", "6:30 PM", "away", "Loomis", "loss", "0-3"],
        ["Boys Varsity Soccer", "10/13/2018", "3:30 PM", "away", "Deerfield", "loss", "0-4"],
        ["Boys Varsity Water Polo", "10/13/2018", "3:30 PM", "away", "Deerfield", "loss", "10-14"],
        ["Boys Thirds Soccer", "10/13/2018", "3:30 PM", "away", "Deerfield", "win", "1-0"],
        ["Boys JV Soccer", "10/13/2018", "3:30 PM", "away", "Deerfield", "win", "3-1"],
        ["Thirds Field Hockey", "10/13/2018", "3:30 PM", "away", "Westminster", "cancel", ""],
        ["Thirds Field Hockey", "10/19/2018", "3:00 PM", "home", "HVRHS", "future", ""],
        ["Thirds Volleyball", "10/19/2018", "4:15 PM", "home", "IMS", "future", ""],
        ["Girls Varsity Soccer", "10/19/2018", "6:30 PM", "home", "Choate", "future", ""],
        ["Varsity Field Hockey", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
        ["Varsity Volleyball", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
        ["JV Volleyball", "10/20/2018", "1:30 PM", "home", "Choate", "future", ""],
        ["Boys Varsity Soccer", "10/20/2018", "2:00 PM", "home", "Choate", "future", ""],
        ["Boys JV Soccer", "10/20/2018", "2:00 PM", "home", "Choate", "future", ""],
        
        
        ]
    
    var myScoreItems = [ScoreItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblScores.dataSource = self
        tblScores.delegate = self
        
        tblScores.rowHeight = 60.0
        
        // Do any additional setup after loading the view.
        
//        var dateComponents = DateComponents()
//        dateComponents.year = 2018
//        dateComponents.month = 10
//        dateComponents.day = 17
//
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)
//
//        var testScore = ScoreItem(myScoreTeam: Team(myTeamName: "Varsity Field Hockey"), myScoreDate: date!, myScoreOpp: Opponent(myOppName: "Westminster"), myScoreResult: .win, myScoreText: "3-0")
//
//        print(testScore)
        
        loadTestScores()
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
        
        print(myScoreItems)
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

}
