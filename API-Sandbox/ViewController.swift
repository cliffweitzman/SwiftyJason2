//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var link: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        loadMovie()
  
    }


    @IBAction func newMovie(sender: AnyObject) {
        loadMovie()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        print(link)
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }
    
    func loadMovie() {
        
        let randomInt: Int = Int(arc4random_uniform(UInt32(25)))
        var allMovies: [Movie] = []
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let moviesData = JSON(value)
                    let allMoviesData = moviesData["feed"]["entry"].arrayValue
                    /*
                     Figure out a way to turn the allMoviesData array into Movie structs!
                     */
                    for movieJSON in allMoviesData {
                        allMovies.append(Movie(json: movieJSON))
                    }
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    self.movieTitleLabel.text = allMovies[randomInt].name
                    
                    var myText1 = allMovies[randomInt].rightsOwner
                    if myText1.containsString(" All Rights Reserved") {
                        myText1 = myText1.stringByReplacingOccurrencesOfString(" All Rights Reserved", withString: "")
                    }
                    if myText1 == "" {
                        myText1 = "N/A"
                    }
                    self.rightsOwnerLabel.text = myText1
                    
                    let myText = allMovies[randomInt].releaseDate
                    self.releaseDateLabel.text = String(myText.characters.dropLast(15))
                    
                    self.priceLabel.text = "$" + String(allMovies[randomInt].price)
                    
                    self.loadPoster(allMovies[randomInt].poster)
                    self.link = allMovies[randomInt].link
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}

