//
//  SecondViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-12.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class SearchMovieViewController: UITableViewController {
    
    @IBOutlet weak var searchField: UITextField!
    
    var filteredMovies : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if filteredMovies.count < 1 {

            //default -- star wars
            searchField.text = "star wars"
            SearchButtonPressed(self)
            searchField.text = ""
        }
    }
    
    //Constant
    //https://www.omdbapi.com/?s=%@&page=%ld&apikey=e3770048
    
    let API_KEY = "e3770048"
    let MOVIE_URL = "https://www.omdbapi.com/"
    let APP_ID = "8ef1d43040955dcd731d9059d85ce0b8"
    
    @IBAction func SearchButtonPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        //get searchterm
        if let term = searchField.text?.lowercased() {
            
            var searchTerm = term
            
            if searchTerm.hasSuffix(" ") {
                searchTerm = String(searchTerm.dropLast())
                print("search terms ends with space")
            }
        
            //create parameters
            let page : String = String(1)
            let params : [String : String] = ["page" : page, "s" : searchTerm, "apikey" : API_KEY]
            
            getMovieData(url: MOVIE_URL, parameters: params)
            
        }
        
        //dismisses keyboard
        searchField.resignFirstResponder()
    }
    
    
    //MARK: -- tableviewController --
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredMovies.count == 0 {
            self.tableView.setEmptyMessage("No movies found")
        } else {
            self.tableView.restore()
        }
        return filteredMovies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Movie *m = _movies[indexPath.row];
        
        //cell.ratingDelegate = self;
        
         let m = filteredMovies[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
            cell.setMovie(containingMovie: m)
            //cell.accessoryType = Item.done ? .checkmark : .none
            return cell;
    }
    
    //MARK: -- Networking --
    
    func getMovieData(url: String, parameters: [String : String]) {
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess {
                print("Success getting the Movie data")

                let movieJSON : JSON = JSON(response.result.value!)
                //print(movieJSON)
                self.updateMovieData(json: movieJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                //self.cityLabel.text = "Connection issues"
                self.view.backgroundColor = UIColor.red
            }
        }
    }
    
     //MARK: -- JSON Parsing --
    
    func updateMovieData(json: JSON) {
        
        //clear list
        filteredMovies.removeAll()
        
        if let movieArray = json["Search"].array {
            
            //adds all movies
            for i in 0..<(movieArray.count) {
                
                //create object
                let m = Movie()
               
                //get values
                m.title = movieArray[i]["Title"].string!
                m.year = movieArray[i]["Year"].string!
                m.rating = Double(arc4random_uniform(5));
                
                //get poster
                let posterURL = movieArray[i]["Poster"].string
                
                if let url = NSURL(string: posterURL!) {
                    if let data = NSData(contentsOf: url as URL) {
                        m.poster = UIImage(data: data as Data)
                        m.imageUrl = posterURL!
                    }
                }
                filteredMovies.append(m)
            }
            SVProgressHUD.dismiss()
            tableView.reloadData()
        }
        else {
            //create object
        print("Movies unavailable")
        SVProgressHUD.dismiss()
        tableView.reloadData()
        }
    }
    
    //MARK: -- prep for segue --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchToDetail" {
            let dcController = segue.destination as! DetailedMovieViewController
            if let selectedIndexPath : Int = self.tableView?.indexPathForSelectedRow?.row {
            dcController.selectedMovie = filteredMovies[selectedIndexPath]
            }
        }
    }
}

//:MARK - tableview extension
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}



