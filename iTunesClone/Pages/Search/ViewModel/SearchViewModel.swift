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
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .flatMapLatest { searchTerm -> Observable<[SearchResult]> in
                SearchAPIService.fetchSearchResult(term: searchTerm)
                    .map { $0.results }
                    .catch { error -> Observable<[SearchResult]> in
                        errors.onNext(error)
                        return Observable.just([])
                    }
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)
        
        return Output(searchResults: searchResults, errors: errors)
    }
    
    private let disposeBag = DisposeBag()
}
