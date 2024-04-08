//
//  SearchViewController.swift
//  iTunesClone
//
//  Created by hwijinjeong on 4/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchViewController: UIViewController {
    
    let tableView = UITableView()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
   
    let viewModel = SearchViewModel()
    
    func bind() {
        let input = SearchViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked.asControlEvent(),
            searchText: searchBar.rx.text.orEmpty.asControlProperty()
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchResults
            .bind(to: tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) { index, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        output.errors
            .subscribe(onNext: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
