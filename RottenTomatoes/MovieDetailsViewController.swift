//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by anjaneya kamat on 9/15/15.
//  Copyright (c) 2015 anjaneya kamat. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var mpaRatingLabel: UILabel!
    @IBOutlet weak var tomatoIcon: UIImageView!
    @IBOutlet weak var ratingPercentLabel: UILabel!
    
    var moviesJSON: NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieTitle!.text = moviesJSON["title"] as? String
        self.movieSynopsis!.text = moviesJSON["synopsis"] as? String
        
        let posterUrl = NSURL(string: moviesJSON.valueForKeyPath("posters.original") as! String)!
        self.posterImage.setImageWithURL(posterUrl)

        self.mpaRatingLabel!.text = moviesJSON["mpaa_rating"] as? String



    }

}
