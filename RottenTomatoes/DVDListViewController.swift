//
//  DVDListViewController.swift
//  RottenTomatoes
//
//  Created by anjaneya kamat on 9/15/15.
//  Copyright (c) 2015 anjaneya kamat. All rights reserved.
//

import UIKit

class DVDListViewController: UIViewController {

    
    @IBOutlet weak var dvdsTableView: UITableView!
    @IBOutlet weak var noNetworkLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var moviesArray: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refresh(sender:AnyObject) {
        fetchMovies()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController!.navigationItem.title = "Top DVDs"
        fetchMovies()
    }
    
    func fetchMovies() {
            self.noNetworkLabel.hidden = true;
            self.spinner.startAnimating()
            let rottenTomatoesUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=8jtempshxkbkmd6m8khxk3yy&limit=50&country=us"
            let request = NSMutableURLRequest(URL: NSURL(string:rottenTomatoesUrlString)!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                var errorValue: NSError? = nil
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as! NSDictionary? {
                    self.moviesArray = dictionary["movies"] as! NSArray?
                    self.dvdsTableView.reloadData()
                    self.spinner.stopAnimating()
                }
            })

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dvdsTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieJSON = moviesArray![indexPath.row] as! NSDictionary
        cell.movieTitle!.text = movieJSON["title"] as? String
        cell.mpaRatingLabel!.text = movieJSON["mpaa_rating"] as? String
        
        let posterUrl = NSURL(string: movieJSON.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterImage.setImageWithURL(posterUrl)
        

        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.dvdsTableView.indexPathForCell(cell)
        
        let moviesJSON = moviesArray![indexPath!.row] as! NSDictionary
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.moviesJSON = moviesJSON
    }
    


}
