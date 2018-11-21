//
//  TeamTableViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/24/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTeamRecord: UILabel!
    
}

class TeamTableViewController: UITableViewController {
    
    var myRecordItems = [TeamRecordItem]()
    
    var selectedTeam = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        loadTeamRecords()
        
        
//        myRecordItems += [
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "Varsity Field Hockey"), myRecordWins: 3, myRecordLosses: 1, myRecordTies: 0),
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "JV Field Hockey"), myRecordWins: 2, myRecordLosses: 2, myRecordTies: 0),
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "Thirds Field Hockey"), myRecordWins: 1, myRecordLosses: 2, myRecordTies: 2),
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "Girls Varsity Soccer"), myRecordWins: 7, myRecordLosses: 1, myRecordTies: 3),
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "Girls JV Soccer"), myRecordWins: 4, myRecordLosses: 4, myRecordTies: 0),
//            TeamRecordItem(myRecordTeam: Team(myTeamName: "Girls Thirds Soccer"), myRecordWins: 9, myRecordLosses: 0, myRecordTies: 2)
//
//
//
//        ]
    }
    
    func loadTeamRecords() {
        for team in allTeams {
            var wins = 0
            var losses = 0
            var ties = 0
            
            for score in myScoreItems {
                if team.myTeamName == score.myScoreTeam.myTeamName {
                    switch score.myScoreResult {
                    case .win: wins += 1
                    case .lose: losses += 1
                    case .tie: ties += 1
                    default: break
                    }
                }
            }
            
            myRecordItems.append(TeamRecordItem(myRecordTeam: team, myRecordWins: wins, myRecordLosses: losses, myRecordTies: ties))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecordItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableTeamRecord", for: indexPath) as! TeamTableViewCell

        // Configure the cell...

        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 15/255, green: 43/255, blue: 91/255, alpha: 0.2)
        } else {
            cell.backgroundColor = .white
        }
        
        let recordItem = myRecordItems[indexPath.row]
        
        let teamName = recordItem.myRecordTeam.myTeamName
        
        let record = recordItem.shortRecord
        
        cell.lblTeamName.text = teamName
        cell.lblTeamRecord.text = record
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell {
            selectedTeam = cell.lblTeamName.text!
        }
        performSegue(withIdentifier: "segueTeamRecord", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTeamRecord" {
            if let destination = segue.destination as? TeamScoreViewController {
                destination.teamName = selectedTeam
            }
        }
    }
}
