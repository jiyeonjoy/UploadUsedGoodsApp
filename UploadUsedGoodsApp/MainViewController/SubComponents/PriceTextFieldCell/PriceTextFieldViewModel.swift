//
//  PriceTextFieldViewModel.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    // ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        self.showFreeShareButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" }, // priceValue 0 이거나
                freeShareButtonTapped.map { _ in false } // 무료나눔 버튼을 누른 경우 -> 버튼을 숨긴다.
            )
            .asSignal(onErrorJustReturn: false) // 에러가 났을 경우도 버튼을 숨긴다.
        
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty()) // 무료나눔버튼을 누른 경우 값이 리셋된다. 에러난 경우 아무일도 일어나지 않는다.
    }
}
