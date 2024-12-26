//
//  NetworkingManager.swift
//  MovieBrowser2
//
//  Created by Edmund Cheong on 25/12/2024.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {} // Prevent external initialization
    
    
    func fetchNowPlayingMovies(language: String, page: Int) async throws -> [Movie] {
        let baseURL = "https://api.themoviedb.org/3/movie/now_playing"
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        components.queryItems = queryItems
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        // Fetch the API key from the plist
            guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
                  let keys = NSDictionary(contentsOfFile: path),
                  let apiKey = keys["movieApiKey"] as? String else {
                throw NetworkError.apiKeyNotFound // Custom error for missing API key
            }
            
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer \(apiKey)" // Adjust format as needed
            ]
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            
            return decodedResponse.results
        }
        
        func searchMoviesBasedOnTitile(movieTitle: String) async throws -> [Movie] {
            let baseURL = "https://api.themoviedb.org/3/search/movie"
            guard let url = URL(string: baseURL) else {
                throw NetworkError.invalidURL
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "query", value: "\(movieTitle)"),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = queryItems
            
            guard let finalURL = components.url else {
                throw NetworkError.invalidURL
            }
            
            // Fetch the API key from the plist
                guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
                      let keys = NSDictionary(contentsOfFile: path),
                      let apiKey = keys["movieApiKey"] as? String else {
                    throw NetworkError.apiKeyNotFound // Custom error for missing API key
                }
                
                var request = URLRequest(url: finalURL)
                request.httpMethod = "GET"
                request.timeoutInterval = 10
                request.allHTTPHeaderFields = [
                    "accept": "application/json",
                    "Authorization": "Bearer \(apiKey)" // Adjust format as needed
                ]
            
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            
            return decodedResponse.results
        }
            
        
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
        case apiKeyNotFound
    }

