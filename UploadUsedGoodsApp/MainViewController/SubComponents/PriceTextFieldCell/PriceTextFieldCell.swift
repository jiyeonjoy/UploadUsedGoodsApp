//
//  PriceTextFieldCell.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    let freeShareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel) {
        viewModel.showFreeShareButton
            .map { !$0 } // 버튼이 눌렀으면 false 로 들어와서 반대로 true 로 넘겨서
            .emit(to: freeShareButton.rx.isHidden) // 버튼이 숨겨지는 처리가 true 가 되어 버튼이 사라진다.
            .disposed(by: disposeBag)
        
        viewModel.resetPrice // 뷰모델의 resetPrice 가 일어나면
            .map { _ in "" } // 값을 "" 빈값으로 받아
            .emit(to: priceInputField.rx.text) // priceInputField 텍스트를 "" 빈값 처리한다.
            .disposed(by: disposeBag)
        
        priceInputField.rx.text // priceInputField 값을 받아서
            .bind(to: viewModel.priceValue) // 뷰모델의 priceValue 값을 넘겨준다.
            .disposed(by: disposeBag)
        
        freeShareButton.rx.tap // freeShareButton 버튼을 누르면
            .bind(to: viewModel.freeShareButtonTapped) // viewModel 의 freeShareButtonTapped 를 호출한다.
            .disposed(by: disposeBag)
    }

    private func attribute() {
        freeShareButton.setTitle("무료나눔 ", for: .normal)
        freeShareButton.setTitleColor(.orange, for: .normal)
        freeShareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeShareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeShareButton.tintColor = .orange
        freeShareButton.backgroundColor = .white
        freeShareButton.layer.borderColor = UIColor.orange.cgColor
        freeShareButton.layer.borderWidth = 1.0
        freeShareButton.layer.cornerRadius = 10.0
        freeShareButton.clipsToBounds = true
        freeShareButton.isHidden = true
        freeShareButton.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        [priceInputField, freeShareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
}

