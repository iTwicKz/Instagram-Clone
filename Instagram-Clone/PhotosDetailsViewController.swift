//
//  PhotosDetailsViewController.swift
//  Instagram-Clone
//
//  Created by Takashi Wickes on 1/18/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit

class PhotosDetailsViewController: UIViewController     {



    @IBOutlet weak var detailedPhoto: UIImageView!

    var passedPhoto: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = passedPhoto["images"]!["standard_resolution"]!!["url"] as! String
        print(urlString)
        
        let imageUrl = NSURL(string: urlString)
        detailedPhoto.setImageWithURL(imageUrl!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation



}
