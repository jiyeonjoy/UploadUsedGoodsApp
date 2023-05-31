//
//  MainModel.swift
//  UploadUsedGoodsApp
//
//  Created by Jiyeon Choi on 2023/05/31.
//

import Foundation

struct MainModel {
    func setAlert(errorMessages: [String]) -> (title: String, message: String?) {
        let title = errorMessages.isEmpty ? "성공": "실패"
        let message = errorMessages.isEmpty ? nil : errorMessages.joined(separator: "\n")
        return (title: title, message: message)
    }
}
