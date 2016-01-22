//
//  InstaViewController.swift
//  Instagram-Clone
//
//  Created by Takashi Wickes on 1/7/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import AFNetworking
import UIKit

class InstaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pictures: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.networkRequest();

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }
    
    func networkRequest () {
        
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=e05c462ebd86446ea48a5af73769b602")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //                            NSLog("response: \(responseDictionary)")
                            
                            self.pictures = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    //MARK: Refresh Functions
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            self.networkRequest()
        })
    }
    
    
    //MARK: Infinite Scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
            
                self.isMoreDataLoading = false
                
                // Update data source with latest data

                self.networkRequest()
                self.tableView.reloadData()
                scrollView.contentOffset.y = 0;

                
            }
            
            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pictures = pictures {
            return pictures.count
        }
        else {
            return 0
        }    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
    
        if(pictures != nil){
            let pic = pictures![indexPath.row]
            print("Ahhhhh darn")

            let filterString = pic["filter"] as! String
            print(filterString)
            
            let urlString = pic["images"]!["standard_resolution"]!!["url"] as! String
            print(urlString)
            
            let imageUrl = NSURL(string: urlString)
            cell.instaImageView.setImageWithURL(imageUrl!)
            
            
            let userUrl = pic["user"]!["profile_picture"] as! String
            
            let userImageUrl = NSURL(string: userUrl)
            cell.userImage.setImageWithURL(userImageUrl!)
            
            var likesCountNum = pic["likes"]!["count"] as! NSNumber
            let likesCount = "\(likesCountNum) likes"
            cell.likesLabel.text = likesCount
            
            if let descriptionText = pic["caption"]!["text"] {
                let descriptionString = pic["caption"]!["text"] as! String?
                cell.descriptLabel.text = descriptionString

            }

        }
        
        
//        
//        let urlString = picture["images"]!["standard_resolution"]!!["url"] as! String
//        let pictureString = urlString
        
        
        
//        let user = picture["user"]!["username"] as! String
//        
//        cell.textLabel!.text = "row \(indexPath.row)"

        
        print("row \(indexPath.row)")
        
        return cell
        
    }
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var vc = segue.destinationViewController as! PhotosDetailsViewController
        
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        
        let passPhoto = pictures![indexPath!.row]
        
        vc.passedPhoto = passPhoto
        
        
        //         Get the new view controller using segue.destinationViewController.
        //         Pass the selected object to the new view controller.
    }

}
