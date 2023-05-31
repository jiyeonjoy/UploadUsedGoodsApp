//
//  MainViewModel.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import RxSwift
import RxCocoa

struct MainViewModel {
    let titleTextFieldCellViewModel = TitleTextFieldViewModel()
    let priceTextFieldCellViewModel =  PriceTextFieldCellViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    // ViewModel -> View
    let cellData: Driver<[String]>
    let presentAlert: Signal<Alert>
    let push: Driver<CategoryViewModel>
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    let submitButtonTapped = PublishRelay<Void>()
    
    init() {
        // MARK:-cell data
        let title = Observable.just("글 제목")
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel
            .selectedCategory // 카테고리 뷰모델에서 selectedCategory
            .map { $0.name } // 선택한 카테고리의 이름을 가져온다.
            .startWith("카테고리 선택") // 처음에는 선택된게 없으므로 "카테고리 선택" 이 이름이다.
        
        let price = Observable.just("₩ 가격 (선택사항)") // 입력하지 않아도 된다. 입력안하면 무료나눔. 초기 힌트 값
        let detail = Observable.just("내용을 입력하세요.") // 초기 힌트 값
        
        self.cellData = Observable
            .combineLatest( // 각 값을 리스트로 전달.
                title,
                category,
                price,
                detail
            ) { [$0, $1, $2, $3] }
            .asDriver(onErrorDriveWith: .empty()) // 에러난 경우 빈값
        
        // MARK:-present alert
        let titleMessage = titleTextFieldCellViewModel
            .titleText
            .map { $0?.isEmpty ?? true } // 글 제목 없으면 true
            .startWith(true) // 처음에는 글 제목 없으므로 true
            .map { $0 ? ["- 글 제목을 입력해주세요."] : [] } // true 면 글 제목 입력하라는 alert 뜸.
        
        let categoryMessage = categoryViewModel
            .selectedCategory
            .map { _ in false } // 카테고리 선택하면 false
            .startWith(true) // 처음에는 true
            .map { $0 ? ["- 카테고리를 선택해주세요."] : [] }
        
        let detailMessage = detailWriteFormCellViewModel
            .contentValue
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map { $0 ? ["- 내용을 입력해주세요."] : [] }
        
        let errorMessages = Observable
            .combineLatest(
                titleMessage,
                categoryMessage,
                detailMessage
            ) { $0 + $1 + $2 } // 에러메시지는 다 더한다. 리스트임.
        
        self.presentAlert = submitButtonTapped
            .withLatestFrom(errorMessages) { $1 }
            .map {
                errorMessages -> (title: String, message: String?) in
                let title = errorMessages.isEmpty ? "성공": "실패"
                let message = errorMessages.isEmpty ? nil : errorMessages.joined(separator: "\n")
                return (title: title, message: message)
            }
            .asSignal(onErrorSignalWith: .empty())
        
        // MARK:-push
        self.push = itemSelected
            .compactMap { row -> CategoryViewModel? in
                guard case 1 = row else {
                    return nil
                }
                return categoryViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
