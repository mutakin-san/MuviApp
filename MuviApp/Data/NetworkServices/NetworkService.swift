import Alamofire
import Foundation
import Moya
import ObjectMapper
import RxSwift
import SystemConfiguration.CaptiveNetwork

final class NetworkService {
    static let shared = NetworkService()

    func connect<T: Mappable>(api: MovieAPI, mappableType: T.Type) -> Observable<T> {
        let provider = MoyaProvider<MovieAPI>()
        let subject = ReplaySubject<T>.createUnbounded()

        provider.request(api) { (result) in
            switch result {
            case .success(let value):
                do {
                    guard
                        let jsonResponse = try value.mapJSON() as? [String: Any]
                    else {
                        subject.onError(ApiError.invalidJSONError)
                        return
                    }
                    
                    guard value.statusCode == 200 else {
                        let message = jsonResponse["status_message"] as? String
                        subject.onError(
                            ApiError.middlewareError(
                                code: value.statusCode,
                                message: message
                            )
                        )
                        return
                    }

                    let map = Map(mappingType: .fromJSON, JSON: jsonResponse)
                    guard let responseObject = mappableType.init(map: map)
                    else {
                        subject.onError(ApiError.failedMappingError)
                        return
                    }

                    subject.onNext(responseObject)
                    subject.onCompleted()
                } catch {
                    subject.onError(ApiError.invalidJSONError)
                }
            case .failure:
                subject.onError(ApiError.connectionError)
            }
        }

        return subject
    }
}
