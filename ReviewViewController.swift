//
//  ReviewViewController.swift
//  CalabarYellowPages
//
//  Created by Mmumene Egbai on 23/09/2017.
//  Copyright © 2017 calabarpages. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addReview(_ sender: Any) {
    }
    @IBOutlet weak var reviewTable: UITableView!
    lazy var listingModel = DataModel()
    var url = ""
    var tableData:Array<ReviewModel> = Array<ReviewModel>()
    var indicator = UIActivityIndicatorView()
    var pageData:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewTable.delegate = self
        self.reviewTable.dataSource = self
        let parentController = self.tabBarController as? PlusViewTabBarViewController
        listingModel = (parentController?.data)!
        url = DataModel.Url + "api/get_reviews?q=\(listingModel.Slug)&p=1"
        let nib = UINib(nibName: "reviewCell", bundle: nil)
        reviewTable.register(nib, forCellReuseIdentifier: "cell")
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        get_data(url)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_data(_ url:String)
    {
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error=\(String(describing:error))")
                return
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(jsonResult)
                let data = jsonResult["Data"] as! NSArray
                print(data)
                self.pageData = (jsonResult["Page"] as! NSDictionary) ["Next"] as! Bool
                for item in data{
                    let tmm = item as! NSDictionary
                    let data = ReviewModel()
                    data.comment = tmm["Comment"] as? String
                    data.name = tmm["Name"] as? String
                    data.rating = tmm["Rating"] as? Float
                    self.tableData.append(data)
                    
                }
                    self.hideIndicator()
                    self.reviewTable.reloadData()
                
            }
            catch{
                self.hideIndicator()
            }
        })
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTable.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        let dataForCell = tableData[indexPath.row]
        cell.rating.rating = dataForCell.rating!
        cell.reviewersName.text = dataForCell.name!
        cell.reviewMessage.text = dataForCell.comment!
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
    
    func hideIndicator(){
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }

}
