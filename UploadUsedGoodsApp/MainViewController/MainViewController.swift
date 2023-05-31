//
//  MainViewController.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        
    }
    
    func attribute() {
        title = "중고거래 글쓰기"
        view.backgroundColor = .systemGroupedBackground
    }
    
    func layout() {}
}

typealias Alert = (title: String, message: String?)
extension Reactive where Base: MainViewController {
    var setAlert: Binder<(title: String, message: String?)> {
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let alert = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(alert)
            base.present(alertController, animated: true, completion: nil)
        }
    }
}
