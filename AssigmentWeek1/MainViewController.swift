//
//  MainViewController.swift
//  AssigmentWeek1
//
//  Created by Nam Pham on 2/18/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import AFNetworking
import VHUD

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableViewMovies: UITableView!
    @IBOutlet weak var lblNetworkWarning: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let baseUrl = "http://image.tmdb.org/t/p/w500";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        //tableViewMovies.delegate = self
        tableViewMovies.dataSource = self
        searchBar.delegate = self
        
        initNetworkWarning()
        
        showLoadingView()
        loadMovies()
        
        //initialize refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableViewMovies.insertSubview(refreshControl, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        cell.lblTitle?.text = movies[indexPath.row].value(forKeyPath: "title") as? String
        cell.lblDescription?.text = movies[indexPath.row].value(forKeyPath: "overview") as? String
        
        let url = baseUrl + (movies[indexPath.row].value(forKeyPath: "poster_path") as? String)!
        //cell.ivThumbnail.setImageWith(NSURL(string: url) as! URL)
        
    
        let imageRequest = URLRequest(url: NSURL(string: url) as! URL )
        
        cell.ivThumbnail.setImageWith(imageRequest, placeholderImage: nil, success: {
            (imageRequest, imageResponse, image) -> Void in
            // imageResponse will be nil if the image is cached
            if imageResponse != nil {
                print("Image was NOT cached, fade in image")
                cell.ivThumbnail.alpha = 0.0
                cell.ivThumbnail.image = image
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    cell.ivThumbnail.alpha = 1.0
                })
            } else {
                print("Image was cached so just update the image")
                cell.ivThumbnail.image = image
            }
        }, failure: {
            (imageRequest, imageResponse, error) -> Void in
        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewMovies.deselectRow(at: indexPath, animated: true)
    }
    
    var filteredData = [NSDictionary]()

    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        print("searchText")
        self.filteredData = searchText.isEmpty ? self.movies : self.movies.filter { (item: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = item.value(forKeyPath: "title") as! String
            return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        print("reload")
        tableViewMovies.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var movies = [NSDictionary]()
    
    
    func loadMovies(){
        let apiKey = "7519cb3f829ecd53bd9b7007076dbe23"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if error != nil {
                                    self.lblNetworkWarning.isHidden = false;
                                    self.hideLoadingView()
                                }else if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                        self.movies = responseDictionary["results"] as!  [NSDictionary]
                                        self.filteredData = self.movies
                                        print("response: \(self.movies)")
                                        self.hideLoadingView()
                                        self.tableViewMovies.reloadData()
                                    }
                                }
            })
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let apiKey = "7519cb3f829ecd53bd9b7007076dbe23"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if error != nil {
                                    self.lblNetworkWarning.isHidden = false;
                                    self.hideLoadingView()
                                }else if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                        self.movies = responseDictionary["results"] as!  [NSDictionary]
                                        self.tableViewMovies.reloadData()
                                        //tell refresh control stop spinning
                                        refreshControl.endRefreshing();
                                    }
                                }
            })
        task.resume()
    }
    
    func showLoadingView(){
        var content = VHUDContent(.loop(3.0))
        content.loadingText = "Loading.."
        content.completionText = "Finish!"
        
        VHUD.show(content)
    }
    
    func hideLoadingView(){
        // duration, deley(Option), text(Option), completion(Option)
        VHUD.dismiss(0.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVc = segue.destination as! MovieDetailController
        let indexPath = tableViewMovies.indexPathForSelectedRow
        nextVc.data = self.movies[(indexPath?.row)!]
    }
    
    func initNetworkWarning(){
        lblNetworkWarning.isHidden = true
        lblNetworkWarning.textAlignment = .center
        
    }

}
