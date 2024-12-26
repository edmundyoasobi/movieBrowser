//
//  MovieTableViewController.swift
//  MovieBrowser2
//
//  Created by Edmund Cheong on 25/12/2024.
//

import UIKit
import SDWebImage


class MovieTableViewController: UITableViewController {
    
    var currentPage = 1
    var isLoading = false
    
    private var searchController : UISearchController!
    
    private var movies: [Movie] = []
    
    private var filteredMovies: [Movie] = [] // For filtered search results
    
    var indicator = UIActivityIndicatorView()
    


    lazy var cacheDirectoryPath: URL = {
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return cacheDirectoryPath[0]
    }()
    
    // This is called when the user scrolls near the bottom of the table view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height

        // Check if the user is near the bottom of the table
        if contentOffsetY + height >= contentHeight - 200 && !isLoading {
            currentPage += 1
            fetchMovies(language: "en-US", page: currentPage)
        }
    }
    
    // Fetch movies for the given page
    func fetchMovies(language: String, page: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let newMovies = try await NetworkingManager.shared.fetchNowPlayingMovies(
                    language: "en-US",
                    page: page
                )
                movies.append(contentsOf: newMovies)  // Append the new movies to the existing list
                filteredMovies = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                isLoading = false
            } catch {
                isLoading = false
                showAlert(title: "No Internet", message: "Please check your internet connection")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the estimated row height for performance optimization
          tableView.estimatedRowHeight = 250

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self // To handle search updates
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        
        // Integrate the search bar into the navigation bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        setupActivityIndicator()
        indicator.startAnimating()

        
        fetchMovies(language: "en-US", page: currentPage)
        indicator.startAnimating()
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    private func setupActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.style = UIActivityIndicatorView.Style.large
            indicator.center = self.view.center
            self.view.addSubview(indicator)
        }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filteredMovies.count : movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = searchController.isActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.releaseDate.text = movie.releaseDate
        // Configure the cell...
        let baseURL = "https://image.tmdb.org/t/p/original"
        if let posterPath = movie.posterPath, let posterURL = URL(string: baseURL + posterPath) {
            // Use SDWebImage to set the image
            cell.moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(systemName: "photo")) { (image, error, cacheType, url) in
                if error != nil {
                    print(error!)
                }
            }
        } else {
            // Placeholder if the URL is invalid
            cell.moviePoster.image = UIImage(systemName: "photo")
        }

            return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 250
    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "movieDetailSegue" {
            let movieDetailViewController = segue.destination as! MovieDetailsViewController
            
            if let selectedIndexPath = tableView.indexPathsForSelectedRows?.first {
                movieDetailViewController.movie = searchController.isActive ? filteredMovies[selectedIndexPath.row] : movies[selectedIndexPath.row]
            }
        }
    }
    

}
extension MovieTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        indicator.startAnimating()
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            // Reset search results if the search text is empty
            filteredMovies = movies
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            tableView.reloadData()
            
            return
        }
        
        Task {
            do {
                filteredMovies = try await NetworkingManager.shared.searchMoviesBasedOnTitile(movieTitle: searchText.lowercased())
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                
            }catch {
                        showAlert(title: "No Internet", message: "Please check your internet connection")
                    }
           
                }
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        tableView.reloadData()
    }


    
}
