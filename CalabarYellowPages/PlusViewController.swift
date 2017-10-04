//
//  PlusViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/25/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workDaysLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var website: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var galleryCollection: UICollectionView!
    
    
    lazy var listingModel = DataModel()
    var TableData:Array<DataModel> = Array<DataModel>()
    var Description = ""
    var titleM = ""
    var Address = ""
    var websiteUrl = ""
    var special = ""
    var work = ""
    var phone = ""
    var logo = ""
    var review = ""
    @IBOutlet weak var titleBar: UINavigationItem!
    var imageGallery:[String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentController = self.tabBarController as? PlusViewTabBarViewController
        listingModel = (parentController?.data)!
        titleBar.title = listingModel.Title
        descriptionLabel.text = listingModel.Description
        addressLabel.text =  listingModel.Address
        workDaysLabel.text = listingModel.WorkDays
        specialLabel.text = listingModel.Specialisation
        phoneLabel.text = listingModel.Phone
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(PlusViewController.phoneTapFunction))
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(phoneTap)
        let reviewData = "\(listingModel.review) Reviews"
        reviewLabel.text = reviewData
        website.text = listingModel.Web
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlusViewController.tapFunction))
        website.isUserInteractionEnabled = true
        website.addGestureRecognizer(tap)
        self.galleryCollection.delegate = self
        self.galleryCollection.dataSource = self
        logoView.layer.cornerRadius = logoView.frame.size.width/2
        logoView.clipsToBounds = true
        imageGallery = listingModel.ImageAray
        if let url = URL(string: listingModel.Image), let datas = try? Data(contentsOf: url){
            logoView.image = UIImage(data: datas)
        }
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        galleryCollection.register(nib, forCellWithReuseIdentifier: "cCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! CollectionViewCell
        if let url = URL(string: (imageGallery?[indexPath.row])!), let content = try? Data(contentsOf: url){
            collectionCell.galleryImage?.image = UIImage(data: content)
        }
        return collectionCell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let countOfSections = imageGallery?.count{
            return countOfSections
        }else{
            return 0
        }
    }
    
    func webTapFunction(sender:UITapGestureRecognizer) {
        let url = NSURL(string: listingModel.Web)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func phoneTapFunction(sender:UITapGestureRecognizer){
        if let url = NSURL(string: "tel://\(listingModel.Phone)"), UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
        
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
