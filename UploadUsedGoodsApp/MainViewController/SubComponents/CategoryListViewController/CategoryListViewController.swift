//
//  CategoryListViewController.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryListViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CategoryViewModel) {
        // viewModel 에서 카테고리 리스트 정보를 받아와서 리스트 그려준다.
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(
                    withIdentifier: String(describing: UITableViewCell.self),
                    for: IndexPath(row: row, section: 0)
                )
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: disposeBag)
        
        // viewModel 에서 pop 이 일어나면 해당 뷰를 닫는다.
        viewModel.pop
            .emit(onNext: {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 테이블 뷰에서 아이템을 선택하면 viewModel 의 itemSelected 에 해당 인덱스를 넘겨준다.
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        view.backgroundColor = .systemGroupedBackground
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
