//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by anjaneya kamat on 9/15/15.
//  Copyright (c) 2015 anjaneya kamat. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noNetworkLabel: UILabel!
    
    var moviesArray: NSArray?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.navigationItem.title = "Top Movies"
        fetchMovie()
    }
    
    func fetchMovie() {
            let rottenTomatoesUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=8jtempshxkbkmd6m8khxk3yy&limit=50&country=us"
            let request = NSMutableURLRequest(URL: NSURL(string:rottenTomatoesUrlString)!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                var errorValue: NSError? = nil
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as! NSDictionary? {
                    self.moviesArray = dictionary["movies"] as! NSArray?
                    self.moviesTableView.reloadData()
                } 
            })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieJSON = moviesArray![indexPath.row] as! NSDictionary
        cell.movieTitle!.text = movieJSON["title"] as? String
        cell.mpaRatingLabel!.text = movieJSON["mpaa_rating"] as? String
        
        let posterUrl = NSURL(string: movieJSON.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterImage.setImageWithURL(posterUrl)


        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTableView.indexPathForCell(cell)
        
        let moviesJSON = moviesArray![indexPath!.row] as! NSDictionary
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.moviesJSON = moviesJSON
    }


}

