//
//  AlamofireSearchAPIService.swift
//  iTunesClone
//
//  Created by hwijinjeong on 4/9/24.
//

import Foundation
import Alamofire
import RxSwift

final class AlamofireSearchAPIService {
    
    static let baseUrl = "https://itunes.apple.com/search"
    
    static func fetchSearchResultWithAlamofire(term: String) -> Observable<SearchModel> {
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let fullUrlString = "\(baseUrl)?term=\(encodedTerm)"
        
        return Observable.create { observer -> Disposable in
            guard let url = URL(string: fullUrlString) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SearchModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(APIError.statusError)
                    }
                }
            
            return Disposables.create()
        }.debug("observable itunes search")
    }
    
}
