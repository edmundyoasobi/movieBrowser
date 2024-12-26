//
//  MovieDetailsViewController.swift
//  MovieBrowser2
//
//  Created by Edmund Cheong on 26/12/2024.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    
    var movie : Movie?
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieRating: UILabel!
    
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    @IBOutlet weak var movieDescription: UILabel!
    
    lazy var cacheDirectoryPath: URL = {
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return cacheDirectoryPath[0]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            navigationItem.title = movie.title
            movieTitle.text = movie.title
            movieRating.text = "\(movie.voteAverage)"
            movieReleaseDate.text = movie.releaseDate
            movieDescription.text = movie.overview
            let baseURL = "https://image.tmdb.org/t/p/original"
            if let posterPath = movie.posterPath, let posterURL = URL(string: "\(baseURL)\(posterPath)") {
                // Use SDWebImage to load and cache the image
                moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(systemName: "photo")) { (image, error, cacheType, url) in
                    if let error = error {
                        print("Failed to load image: \(error.localizedDescription)")
                        self.showAlert(title: "No Internet", message: "Please check your internet connection")
                    }
                }
            } else {
                // Fallback to placeholder if the posterPath is nil
                moviePoster.image = UIImage(systemName: "photo")
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
