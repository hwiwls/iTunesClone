//
//  SearchViewModel.swift
//  iTunesClone
//
//  Created by hwijinjeong on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let searchResults: BehaviorRelay<[SearchResult]>
        let errors: PublishSubject<Error>
    }
    
    func transform(input: Input) -> Output {
        let searchResults = BehaviorRelay<[SearchResult]>(value: [])
        let errors = PublishSubject<Error>()
        
//        input.searchButtonTap
//            .withLatestFrom(input.searchText)
//            .flatMapLatest { searchTerm -> Observable<[SearchResult]> in
//                SearchAPIService.fetchSearchResult(term: searchTerm)
//                    .map { $0.results }
//                    .catch { error -> Observable<[SearchResult]> in
//                        errors.onNext(error)
//                        return Observable.just([])
//                    }
//            }
//            .bind(to: searchResults)
//            .disposed(by: disposeBag)
        
//        input.searchButtonTap
//            .withLatestFrom(input.searchText)
//            .flatMapLatest { searchTerm -> Observable<[SearchResult]> in
//                AlamofireSearchAPIService.fetchSearchResultWithAlamofire(term: searchTerm)
//                    .map { $0.results }
//                    .catch { error -> Observable<[SearchResult]> in
//                        errors.onNext(error)
//                        return Observable.just([])
//                    }
//            }
//            .bind(to: searchResults)
//            .disposed(by: disposeBag)
//
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .flatMapLatest { searchTerm -> Observable<[SearchResult]> in
                AlamofireSearchAPIService.fetchSearchResultWithAlamofireSingle(term: searchTerm)
                    .asObservable()
                    .flatMap { result -> Observable<[SearchResult]> in
                        switch result {
                        case .success(let searchModel):
                            return .just(searchModel.results)
                        case .failure(let error):
                            errors.onNext(error)
                            return .just([])
                        }
                    }
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)

        
        
        
        return Output(searchResults: searchResults, errors: errors)
    }
    
    private let disposeBag = DisposeBag()
}
