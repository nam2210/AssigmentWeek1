//
//  TopRatingController.swift
//  AssigmentWeek1
//
//  Created by Nam Pham on 2/19/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit
import AFNetworking
import VHUD

class TopRatingController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewTopRating: UITableView!
    
    let baseUrl = "http://image.tmdb.org/t/p/w500";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableViewTopRating.delegate = self
        tableViewTopRating.dataSource = self

        
        showLoadingView()
        loadMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
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
    
    var movies = [NSDictionary]()
    
    func loadMovies(){
        let apiKey = "7519cb3f829ecd53bd9b7007076dbe23"
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
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
                                    self.hideLoadingView()
                                }else if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                        self.movies = responseDictionary["results"] as!  [NSDictionary]
                                        print("response: \(self.movies)")
                                        self.hideLoadingView()
                                        self.tableViewTopRating.reloadData()
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
    
    
    
}
