//
//  ViewController.swift
//  coderschool_ios_ass1
//
//  Created by Tran Tien Tin on 6/18/17.
//  Copyright © 2017 phapli. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let baseUrl = "https://image.tmdb.org/t/p/w185"
    var url: URL?
    var movies = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        refreshControl.addTarget(self, action: #selector(ViewController.fetchData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    @IBAction func retry(_ sender: Any) {
        present(alert, animated: true, completion: nil)
        fetchData()
    }
    
    func fetchData() {
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    self.alert.dismiss(animated: false, completion: nil)
                    print ("error \(String(describing: error))")
                    if (error != nil) {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = error?.localizedDescription
                        self.tableView.isHidden = true
                    } else {
                        
                        self.errorLabel.isHidden = true
                        self.tableView.isHidden = false
                        if let data = dataOrNil {
                            if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                print("response: \(responseDictionary)")
                                if let resultData = responseDictionary["results"] as? [NSDictionary] {
                                    self.movies = resultData
                                    self.tableView.reloadData()
                                    self.refreshControl.endRefreshing()
                                }
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            destinationVC.selectedPhotoUrlString = baseUrl + (movies[indexPath.item]["poster_path"] as? String)!
            destinationVC.overviewString = movies[indexPath.item]["overview"] as? String
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
        if let titleMovie = movies[indexPath.item]["title"] as? String{
            cell.title.text = titleMovie
        }
        
        if let overviewMovie = movies[indexPath.item]["overview"] as? String{
            cell.content.text = overviewMovie
        }
        
        if let posterMovieUrl = movies[indexPath.item]["poster_path"] as? String{
            //            print (baseUrl + posterMovieUrl)
            cell.posterImage.setImageWith(URL(string: baseUrl + posterMovieUrl)!)
        } else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterImage.image = nil
        }
        //
        //        // infinite loading: is this the last cell
        //        if indexPath.row == photos.count - 1 {
        //
        //        }
        
        return cell
    }
}
