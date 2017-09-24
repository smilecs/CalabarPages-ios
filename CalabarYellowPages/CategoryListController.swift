//
//  CategoryListController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/21/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class CategoryListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var slug = ""
    var url = DataModel.Url+"api/pluslistings"
    @IBOutlet weak var ti: UINavigationItem!
    var categoryName = "Pluslistings"
    var page:Int = 1
    var dataToPass:DataModel!
    var indicator = UIActivityIndicatorView()
    var TableData:Array<DataModel> = Array<DataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tableview.delegate = self
        self.Tableview.dataSource = self
        self.searchBar.delegate = self
        ti.title = categoryName
        let nib = UINib(nibName: "ListCell", bundle: nil)
        let advertNib = UINib(nibName: "AdvertCell", bundle: nil)
        Tableview.register(nib, forCellReuseIdentifier: "cell")
        Tableview.register(advertNib, forCellReuseIdentifier: "advert")
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        //api/newview?page=" + page + "&q=
        if !slug.isEmpty {
            url = DataModel.Url+"api/categories/"+slug
        }
        get_data(url)
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
        let data = TableData[indexPath.row]
        var cell:PlusViewCell
        switch data.Type{
            case "listing":
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlusViewCell
                    if let url = URL(string: data.Image), let datas = try? Data(contentsOf: url){
                        cell.plusLogo?.image = UIImage(data: datas)
                        
                    }else{
                       let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                        cell.plusLogo.frame = frame
                        cell.plusLogo?.isHidden = true
                    }
                cell.title?.text = data.Title
                cell.Address?.text = data.Address
                cell.workDays?.text = data.WorkDays
                cell.Phone?.text = data.Phone
                cell.special?.text = data.Specialisation
                if data.review.isEmpty{
                    data.review = "0"
                }
                cell.review?.text = data.review
                for view in cell.subviews{
                    if let label = view as? UILabel{
                        if label.text!.isEmpty{
                            label.isHidden = true
                            label.removeFromSuperview()
                        }
                    }
                }
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "advert", for: indexPath) as! PlusViewCell
            if let url = URL(string: data.Image), let datas = try? Data(contentsOf: url){
                cell.advert?.image = UIImage(data: datas)
         
            }
            break
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = TableData.count - 1
        if indexPath.row == lastElement {
            page += 1
            let string = String(page)
            get_data(DataModel.Url+url+"?p="+string)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataToPass = TableData[indexPath.row]
        if dataToPass.IsPlus == "true"{
            indicator.startAnimating()
            indicator.color = UIColor.black
            indicator.backgroundColor = UIColor.yellow
            let categoryList:PlusViewController = self.storyboard?.instantiateViewController(withIdentifier: "plusDetailView") as! PlusViewController
            categoryList.Address = dataToPass.Address
            categoryList.titleM = dataToPass.Title
            categoryList.Description = dataToPass.Description
            categoryList.phone = dataToPass.Phone
            categoryList.work = dataToPass.WorkDays
            categoryList.special = dataToPass.Specialisation
            categoryList.logo = dataToPass.Image
            categoryList.review = dataToPass.review
            categoryList.websiteUrl = dataToPass.Web
            if dataToPass.ImageAray != nil{
                categoryList.imageGallery = dataToPass.ImageAray
            }
            self.performSegue(withIdentifier: "toDetailView", sender: dataToPass)
            /*DispatchQueue.main.async(execute: {() -> Void in
                self.present(categoryList, animated: true, completion: {()-> Void in
                    self.hideIndicator()})
            })*/
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideIndicator()
        if let index = self.Tableview.indexPathForSelectedRow{
            self.Tableview.deselectRow(at: index, animated: true)
        }
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
                let data = jsonResult["Posts"] as! NSArray
                for item in data{
                    let tmm = item as! NSDictionary
                    let tm = tmm["Listing"] as! NSDictionary
                    let dataModel:DataModel = DataModel()
                    dataModel.Type = tmm["Type"] as! String
                    dataModel.Title = tm["CompanyName"] as! String
                    dataModel.Slug = tm["Slug"]as! String
                    dataModel.Phone = tm["Hotline"] as! String
                    dataModel.Address = tm["Address"] as! String
                    dataModel.Specialisation = tm["Specialisation"] as! String
                    dataModel.WorkDays = tm["DHr"] as! String
                    dataModel.Image = tm["Image"] as! String
                    dataModel.Web = tm["Website"] as! String
                    dataModel.Description = tm["About"] as! String
                    dataModel.IsPlus = tm["Plus"] as! String
                    dataModel.review = tm["Reviews"] as! String
                    dataModel.ImageAray? = tm["Images"] as! [String]
                    self.TableData.append(dataModel)
                    
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.Tableview.reloadData()
                })
                
            }
            catch{
                self.hideIndicator()
            }
        })
        task.resume()
        
    }
    
    func hideIndicator(){
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }

   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tabController = segue.destination as? PlusViewTabBarViewController{
            tabController.data = dataToPass
        }
    }
 

}
