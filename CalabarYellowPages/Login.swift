//
//  Login.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 12/8/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class Login: UIViewController, FBSDKLoginButtonDelegate{

    @IBAction func skip(_ sender: Any, forEvent event: UIEvent) {
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "loggedIn"
        
        let currentLevel = 1
        preferences.set(currentLevel, forKey: currentLevelKey)
        
        //  Save to disk
        preferences.synchronize()
        
        
        let logginControl:TabBar =  self.storyboard?.instantiateViewController(withIdentifier: "main") as! TabBar
        DispatchQueue.main.async(execute: {() -> Void in
            self.present(logginControl, animated: true, completion: nil)
        })
    }
   @IBAction func skip(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "loggedIn"
        
        let currentLevel = 1
        preferences.set(currentLevel, forKey: currentLevelKey)
        
        //  Save to disk
        preferences.synchronize()

        
        let logginControl:TabBar =  self.storyboard?.instantiateViewController(withIdentifier: "main") as! TabBar
        DispatchQueue.main.async(execute: {() -> Void in
            self.present(logginControl, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       if(FBSDKAccessToken.current() == nil)
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }else{
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
               self.returnUserData()
            }
        }
    }
    
   func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,gender"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(String(describing: error))")
            }
            else
            {
                let preferences = UserDefaults.standard
                
                let currentLevelKey = "loggedIn"
                
                let currentLevel = 1
                    preferences.set(currentLevel, forKey: currentLevelKey)
                
                //  Save to disk
                let didSave = preferences.synchronize()
                
                if !didSave {
                    //  Couldn't save (I've never seen this happen in real world testing)
                }
                let results = result as! NSDictionary
                let userName : NSString = results.value(forKey: "first_name") as! NSString
                let userEmail : NSString = results.value(forKey: "email") as! NSString
                print("User Email is: \(userEmail)")
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                let params:[String: AnyObject] = [
                    "email" : userEmail,
                    "name" : userName ]
                
                let url = NSURL(string:DataModel.Url + "api/login/facebook")
                let request = NSMutableURLRequest(url: url! as URL)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
               // var err: NSError?
                do{
                    try request.httpBody = JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    
                    let task = session.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode != 200 {
                                print("response was not 200: \(String(describing:response))")
                                return
                            }
                        }
                        if (error != nil) {
                            print("error submitting request: \(String(describing:error))")
                            return
                        }
                        
                        // handle the data of the successful response here
                        
                    }
                    task.resume()
                }
                
                catch{
                    
                }
                
                let logginControl:TabBar = self.storyboard?.instantiateViewController(withIdentifier: "main") as! TabBar
                DispatchQueue.main.async(execute: {() -> Void in
                    self.present(logginControl, animated: true, completion: nil)
                })
                
            }
        })
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
