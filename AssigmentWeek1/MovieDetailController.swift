//
//  MovieDetailController.swift
//  AssigmentWeek1
//
//  Created by Nam Pham on 2/18/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {

    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var scrollDescription: UIScrollView!
    
    var data = NSDictionary()
    let baseUrl = "https://image.tmdb.org/t/p/w500";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = baseUrl + (data.value(forKeyPath: "poster_path") as? String)!
        //ivPoster.setImageWith(NSURL(string: url) as! URL)
        
        let imageRequest = URLRequest(url: NSURL(string: url) as! URL )
        
        ivPoster.setImageWith(imageRequest, placeholderImage: nil, success: {
            (imageRequest, imageResponse, image) -> Void in
            // imageResponse will be nil if the image is cached
            if imageResponse != nil {
                print("Image was NOT cached, fade in image")
                self.ivPoster.alpha = 0.0
                self.ivPoster.image = image
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.ivPoster.alpha = 1.0
                })
            } else {
                print("Image was cached so just update the image")
                self.ivPoster.image = image
            }
        }, failure: {
            (imageRequest, imageResponse, error) -> Void in
        })

        
        initScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initScrollView(){
        //init scroll view
        let contentWidth = scrollDescription.bounds.width
        let contentHeight = scrollDescription.bounds.height * 1.2
        scrollDescription.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        let subviewHeight = CGFloat(120)
        let currentViewOffset = CGFloat(scrollDescription.bounds.height * 0.8);
        
        let frame = CGRect(x: 0, y: currentViewOffset, width: contentWidth, height: subviewHeight).insetBy(dx: 16, dy: 16)
        
        let lblDescription = MyLabel(frame: frame)
        lblDescription.text = (data.value(forKeyPath: "overview") as? String)
        lblDescription.numberOfLines = 5
        lblDescription.textColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lblDescription.sizeToFit()
        lblDescription.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        lblDescription.font.withSize(12.0)
        scrollDescription.addSubview(lblDescription)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
