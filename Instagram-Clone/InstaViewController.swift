//
//  InstaViewController.swift
//  Instagram-Clone
//
//  Created by Takashi Wickes on 1/7/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import AFNetworking
import UIKit

class InstaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pictures: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
    
        if(pictures != nil){
            let pic = pictures![indexPath.row]
            print("Ahhhhh darn")
            
            let user = pic["user"]!["username"] as! String
            print("User \(user)")
            
            cell.userLabel.text = user
            
            let filterString = pic["filter"] as! String
            print(filterString)
            
            let urlString = pic["images"]!["standard_resolution"]!!["url"] as! String
            print(urlString)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
