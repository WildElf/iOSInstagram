//
//  ViewController.swift
//  InstagramEE
//
//  Created by EricDev on 1/21/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
	var grams: [NSDictionary]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            tableView.rowHeight = 320
            tableView.dataSource = self
            tableView.delegate = self
        
			let clientId = "e05c462ebd86446ea48a5af73769b602"
			let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
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
					//NSLog("response: \(responseDictionary)")
					self.grams = responseDictionary["data"] as? [NSDictionary]
                    self.tableView.reloadData()
                        }
					}
			});
			task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gramCell", forIndexPath: indexPath) as! GramTableViewCell
        
        let gram = grams![indexPath.row]
        let profileURL = gram.valueForKeyPath("images.standard_resolution.url") as! String
        
        let imageUrl = NSURL(string: profileURL)
        NSLog("URL: \(profileURL)")
        cell.gramView2.setImageWithURL(imageUrl!)
        cell.gramView2.sizeToFit()
        
      return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let grams = grams {
            return grams.count
        } else {
            return 0
        }
    }
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // do something here
    }
*/
}

