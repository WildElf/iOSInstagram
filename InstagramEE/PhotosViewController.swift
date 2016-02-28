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
		self.tableView.reloadData()
        let refreshControl = UIRefreshControl()
        
	}
	
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
    
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) in
                
                self.tableView.reloadData()
                
                refreshControl.endRefreshing()
                
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
		let imageRequest = NSURLRequest(URL: imageUrl!)
        
        cell.gramView2.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.gramView2.alpha = 0.0
                    cell.gramView2.image = image
                    cell.gramView2.sizeToFit()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.gramView2.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.gramView2.image = image
                    cell.gramView2.sizeToFit()
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
		
		return cell
	}

	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		let vc = segue.destinationViewController as! PhotoDetailsViewController
		
		let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
		
		let gram = grams![indexPath!.row]
		let profileURL = gram.valueForKeyPath("images.standard_resolution.url") as! String
		
		let imageUrl = NSURL(string: profileURL)
		
		vc.photoURL = imageUrl!
		
	}
}

