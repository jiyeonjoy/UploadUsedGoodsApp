//
//  CategoryListViewModel.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import RxSwift
import RxCocoa

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let cellData: Driver<[Category]>
    let pop: Signal<Void>
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    // ViewModel -> ParentsViewModel
    let selectedCategory = PublishSubject<Category>()
    
    init() {
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "게임"),
            Category(id: 3, name: "스포츠/레저"),
            Category(id: 4, name: "유아/아동용품"),
            Category(id: 5, name: "여성패션/잡화"),
            Category(id: 6, name: "뷰티/미용"),
            Category(id: 7, name: "남성패션/잡화"),
            Category(id: 8, name: "생활/식품"),
            Category(id: 9, name: "가구"),
            Category(id: 10, name: "도서/티켓/취미"),
            Category(id: 11, name: "기타")
        ]
        
        self.cellData = Driver.just(categories) // categories 정보를 넘겨서 cellData 를 구독하면 Driver 이기 때문에 미리 넘겨준 값을 가질 수 있다.
        
        itemSelected // 아이템 선택한 인덱스를 이용해 해당 카테고리 값으로 변경해서 넘겨준다.
            .map { categories[$0] }
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        self.pop = itemSelected
        // 뷰단에서 이걸 사용해준다. 아이템이 선택되면 pop 된다.
        // 에러가 나면 빈값을 넘겨주어 에러가 나도 아무일이 일어나지 않도록 한다.
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
