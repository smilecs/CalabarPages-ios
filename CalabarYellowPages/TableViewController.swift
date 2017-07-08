//
//  TableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit



class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var TableData:Array<DataModel> = Array<DataModel>()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    var Searchfilter:Array<DataModel> = Array<DataModel>()
        override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data(DataModel.Url+"/api/categories")
        //admob.adUnitID = "ca-app-pub-9472469694308804/9770170177"
        //admob.rootViewController = self
      //  admob.load(GADRequest())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.yellow

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            let item = self.TableData[indexPath.row]
            cell.label?.text = item.Title
            return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToPass = TableData[indexPath.row]
        let categoryList:CategoryListController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryList") as! CategoryListController
            categoryList.slug = dataToPass.Slug
            categoryList.categoryName = dataToPass.Title
        DispatchQueue.main.async(execute: {() -> Void in
                       self.present(categoryList, animated: true, completion: nil)
            })
     
        
    }
    
    func get_data(_ url:String)
    {
        print("connected")
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                print("\(jsonResult.count)")
                for item in jsonResult{
                    let tm = item as! NSDictionary
                    let dataModel:DataModel = DataModel()
                        dataModel.Title = tm["Category"] as! String
                        dataModel.Slug = tm["Slug"]as! String
                   
                    
                    self.TableData.append(dataModel)
                
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.tableView.reloadData()
                })
                
            }
            catch{
                
            }
        })
        task.resume()
        
    }


 
}
