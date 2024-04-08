//
//  SeachAPIService.swift
//  iTunesClone
//
//  Created by hwijinjeong on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class SearchAPIService {
    
    static func fetchSearchResult(term: String) -> Observable<SearchModel> {
        
        return Observable<SearchModel>.create { observer in
            
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(term)") else {
                
                observer.onError(APIError.invalidURL)
                
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("DataTask Succeed")
                
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Response Error")
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data,
                    let appData = try? JSONDecoder().decode(SearchModel.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("response ok, decoding failure")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create()
        }.debug()
    }
}

