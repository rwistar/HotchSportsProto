//
//  SocialViewController.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 12/10/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import UIKit
import WebKit

class SocialViewController: UIViewController {

    @IBOutlet weak var wkSocialFeed: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://twitter.com/hotchkisssports")!
        wkSocialFeed.load(URLRequest(url: url))

        // Do any additional setup after loading the view.
        
        
        
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

}
