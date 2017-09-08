//
//  PlusTableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var TableData:Array<DataModel> = Array<DataModel>()
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    var indicator = UIActivityIndicatorView()
    var page:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ListCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "cell")
        self.table.delegate = self
        self.table.dataSource = self
        self.searchbar.delegate = self
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.yellow
        get_data(DataModel.Url+"api/pluslistings?page=1")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return TableData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = TableData.count - 1
        if indexPath.row == lastElement {
            page += 1
            let string = String(page)
            get_data(DataModel.Url+"api/pluslistings?p="+string)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         let categoryList:SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchResult") as! SearchViewController
        categoryList.QueryString = searchBar.text!
        DispatchQueue.main.async(execute: {() -> Void in
                 self.present(categoryList, animated: true, completion: nil)
            })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
           }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlusViewCell
        let item = TableData[indexPath.row]
        cell.title?.text = item.Title
        cell.Address?.text = item.Address
        cell.special?.text = item.Specialisation
        cell.workDays?.text = item.WorkDays
        cell.Phone?.text = item.Phone
        cell.review?.text = item.review
        if let url = URL(string: item.Image), let datas = try? Data(contentsOf: url){
            cell.imageView?.image = UIImage(data: datas)
            
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToPass = TableData[indexPath.row]
            let categoryList:PlusViewController = self.storyboard?.instantiateViewController(withIdentifier: "plusDetailView") as! PlusViewController
            categoryList.Address = dataToPass.Address
            categoryList.titleM = dataToPass.Title
            categoryList.imageGallery = dataToPass.ImageAray
            categoryList.Description = dataToPass.Description
            categoryList.phone = dataToPass.Phone
            categoryList.work = dataToPass.WorkDays
            categoryList.special = dataToPass.Specialisation
            categoryList.logo = dataToPass.Image
            categoryList.review = dataToPass.review
            categoryList.logo = dataToPass.Image
            indicator.startAnimating()
            DispatchQueue.main.async(execute: {() -> Void in
                self.present(categoryList, animated: true, completion: self.exitScene)
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
    
    func get_data(_ url:String)
    {
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error= \(error ?? "not found" as! Error)")
                return
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(jsonResult)
                let data = jsonResult["Posts"] as! NSArray
                for item in data{
                    let tmm = item as! NSDictionary
                    let tm = tmm["Listing"] as! NSDictionary
                    let dataModel:DataModel = DataModel()
                    dataModel.Title = (tm["CompanyName"] as! String?)!
                    dataModel.Slug = (tm["Slug"]as! String?)!
                    dataModel.Phone = (tm["Hotline"] as! String?)!
                    dataModel.Address = (tm["Address"] as! String?)!
                    dataModel.Specialisation = (tm["Specialisation"] as! String?)!
                    dataModel.Description = (tm["About"] as! String?)!
                    dataModel.WorkDays = (tm["DHr"] as! String?)!
                    dataModel.Image = (tm["Image"] as! String?)!
                    for itms in (tm["Images"] as! NSArray?)!
                    
                    
                    {
                        dataModel.ImageAray.append(itms as! String)
                    }
                    self.TableData.append(dataModel)
                    
                    
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.exitScene()
                    self.table.reloadData()
                })
                
            }
            catch{
                
            }
        })
        task.resume()
        
    }
    
    func exitScene(){
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }


}
