////
////  APIService.swift
////  MuviApp
////
////  Created by Mutakin on 09/09/25.
////
//
//import Foundation
//
//// MARK: - Movie Service
//class MovieService {
//    private let session: URLSession
//    private let decoder: JSONDecoder
//    
//    init(session: URLSession = .shared) {
//        self.session = session
//        self.decoder = JSONDecoder()
//    }
//    
//    // Generic request method with Authorization header
//    private func request<T: Decodable>(url: URL) async throws -> T {
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(APIConfig.apiKey)", forHTTPHeaderField: "Authorization")
//        
//        let (data, response) = try await session.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            throw APIError.requestFailed
//        }
//        
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            throw APIError.decodingFailed
//        }
//    }
//    // MARK: Home
//    func getPopularMovies() async throws -> [Movie] {
//        guard let url = URL(string: "\(APIConfig.baseURLString)/movie/popular?language=en-US&page=1")
//        else { throw APIError.invalidURL }
//        
//        let response: HomeMovieResponse = try await request(url: url)
//        return response.results
//    }
//    
//    // MARK: Home
//    func getUpcomingMovies() async throws -> [HomeMovie] {
//        guard let url = URL(string: "\(APIConfig.baseURLString)/movie/upcoming?language=en-US&page=1")
//        else { throw APIError.invalidURL }
//        
//        let response: HomeMovieResponse = try await request(url: url)
//        return response.results
//    }
//    
//    // MARK: Home
//    func getNowPlayingMovies() async throws -> [HomeMovie] {
//        guard let url = URL(string: "\(APIConfig.baseURLString)/movie/now_playing?language=en-US&page=1")
//        else { throw APIError.invalidURL }
//        
//        let response: HomeMovieResponse = try await request(url: url)
//        return response.results
//    }
//    
//    // MARK: Search
//    func searchMovies(query: String) async throws -> [SearchMovie] {
//        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
//        guard let url = URL(string: "\(APIConfig.baseURLString)/search/movie?language=en-US&query=\(queryEncoded)&page=1&include_adult=false")
//        else { throw APIError.invalidURL }
//        
//        let response: SearchMovieResponse = try await request(url: url)
//        let genres: [GenreEntity] = try await getGenreList()
//        let genreMap = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0) })
//        
//        // Enrich with top 3 actors
//        var enriched: [SearchMovie] = []
//        for movie in response.results {
//            guard let creditsURL = URL(string: "\(APIConfig.baseURLString)/movie/\(movie.id)/credits") else { continue }
//            let credits: CreditsEntity = try await request(url: creditsURL)
//            let topCast = Array(credits.cast.prefix(3))
//            let enrichedMovie = SearchMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath, genreIds: movie.genreIds, cast: topCast)
//            enriched.append(enrichedMovie)
//        }
//        
//        return enriched.map { movie in
//            var m = movie
//            m.genres = movie.genreIds.compactMap { genreMap[$0] }
//            return m
//        }
//    }
//    
//    // MARK: Details
//    func getMovieDetails(movieId: Int) async throws -> DetailMovie {
//        guard let url = URL(string: "\(APIConfig.baseURLString)/movie/\(movieId)?language=en-US&append_to_response=credits")
//        else { throw APIError.invalidURL }
//        
//        return try await request(url: url)
//    }
//    
//    func getGenreList() async throws -> [GenreEntity] {
//        guard let url = URL(string: "\(APIConfig.baseURLString)/genre/movie/list?language=en-US") else { throw APIError.invalidURL }
//        let response: GenreListResponse = try await request(url: url)
//        return response.genres
//    }
//}
