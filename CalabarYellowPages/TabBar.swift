//
//  TabBar.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 12/8/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        
        let loggedIn = "loggedIn"
        
        if preferences.object(forKey: loggedIn) == nil {
            //  Doesn't exist
            let logginControl:Login = self.storyboard?.instantiateViewController(withIdentifier: "login") as! Login
            DispatchQueue.main.async(execute: {() -> Void in
                self.present(logginControl, animated: true, completion: nil)
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
