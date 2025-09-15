import Foundation
import Moya

enum MovieAPI {
    case popular
    case upcoming
    case nowPlaying
    case search(String)
    case detail(Int)
    case genres
    case credits(Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3")! }

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .upcoming:
            return "/movie/upcoming"
        case .nowPlaying:
            return "/movie/now_playing"
        case .search(_):
            return "/search/movie"
        case .detail(let movieId):
            return "/movie/\(movieId)"
        case .genres:
            return "/genre/movie/list"
        case .credits(let movieId):
            return "/movie/\(movieId)/credits"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        var params: [String: Any] = [
            "language": "en-US",
            "page": 1,
            "include_adult": false
        ]
        
        switch self {
        case .search(let query):
            params["query"] = query
        case .detail(_):
            params["append_to_response"] = "credits"
        default:
            break
        }

        return .requestParameters(parameters: params, encoding: URLEncoding.default)

    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(APIConfig.apiKey)",
        ]
    }

    var sampleData: Data { Data() }
}
