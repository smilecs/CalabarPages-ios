//
//  PlusViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/25/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusViewController: UIViewController {
    var TableData:Array<DataModel> = Array<DataModel>()
    var Description = ""
    var titleM = ""
    var Address = ""
    var Website = ""
    var special = ""
    var work = ""
    var phone = ""
    var logo = ""
    var web = ""
   
    var ImageAray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if let url = URL(string: logo), let datas = try? Data(contentsOf: url){
            profileLogo.image = UIImage(data: datas)
        }*/
        
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
