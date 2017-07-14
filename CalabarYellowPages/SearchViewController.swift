//
//  SearchViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/30/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    var QueryString: String = ""
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationItem!
    var TableData:Array<DataModel> = Array<DataModel>()
    var page:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = QueryString
        self.navBar.backBarButtonItem = back
        self.navBar.leftBarButtonItem = back
        self.navBar.leftItemsSupplementBackButton = true
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        get_data(DataModel.Url+"api/result?page=1&q=" + QueryString)
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = TableData.count - 1
        if indexPath.row == lastElement {
            page += 1
            let string = String(page)
            get_data(DataModel.Url+"api/search?p="+string+"&q=" + QueryString)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return TableData.count
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
               
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        QueryString = searchBar.text!
        indicator.startAnimating()
        get_data(DataModel.Url+"api/search?p=1&q=" + searchBar.text!)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(TableData[indexPath.row].Type == "true"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            let item = TableData[indexPath.row]
            cell.SearchTitle?.text = item.Title
            cell.SearchAddress?.text = item.Address
            cell.SearchSpecialisation?.text = item.Specialisation
            cell.SearchWorkDay?.text = item.WorkDays
            cell.SearchPhone?.text = item.Phone
            if let url = URL(string: item.Image), let datas = try? Data(contentsOf: url){
                cell.SearchLogo.image = UIImage(data: datas)
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell
            let item = TableData[indexPath.row]
            cell.SearchTitle?.text = item.Title
            cell.SearchAddress?.text = item.Address
            cell.SearchSpecialisation?.text = item.Specialisation
            cell.SearchWorkDay?.text = item.WorkDays
            cell.SearchPhone?.text = item.Phone
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToPass = TableData[indexPath.row]
        if(dataToPass.Type == "true"){
            let categoryList:PlusViewController = self.storyboard?.instantiateViewController(withIdentifier: "plusDetailView") as! PlusViewController
            categoryList.Address = dataToPass.Address
            categoryList.titleM = dataToPass.Title
            categoryList.ImageAray = dataToPass.ImageAray
            categoryList.Description = dataToPass.Description
            categoryList.phone = dataToPass.Phone
            categoryList.work = dataToPass.WorkDays
            categoryList.special = dataToPass.Specialisation
            categoryList.web = dataToPass.Web
            categoryList.logo = dataToPass.Image
            DispatchQueue.main.async(execute: {() -> Void in
                self.present(categoryList, animated: true, completion: nil)
            })
            
        }
        
    }
    
    func get_data(_ url:String)
    {
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("Description of : \(error as Optional)")
                return
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
