//
//  VideoViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/17/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit
import WebKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var webVideo: WKWebView!
    
}

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblVideos: UITableView!
    
    var myVideoNames: [String] = ["https://www.youtube.com/embed/FZxMDvDMalM",
        "https://www.youtube.com/embed/aentSZUmFrU",
        "https://www.youtube.com/embed/TFLHlhoto6g"]
    
//    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblVideos.dataSource = self
        tblVideos.delegate = self
        
        tblVideos.rowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myVideoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableVideo", for: indexPath) as! VideoTableViewCell
        
        // Configure the cell...
        
//        let videoURL = URL(string: myVideoURLS[indexPath.row])
        
        let name = myVideoNames[indexPath.row]
        
//        let videoString : String? = Bundle.main.path(forResource: name, ofType: "mp4")
//        let unwrappedVideoString = videoString!
//
//        let videoURL = URL(fileURLWithPath: unwrappedVideoString)
//
//
//        player = AVPlayer(url: videoURL)
//
//        let layer = AVPlayerLayer(player: player)
//        layer.frame = cell.viewVideo.bounds
//        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//        cell.viewVideo.layer.addSublayer(layer)
//
//        //player?.play()

        let view = cell.webVideo
        view?.load(URLRequest(url: URL(string: name)!))
        
        return cell
    }
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
