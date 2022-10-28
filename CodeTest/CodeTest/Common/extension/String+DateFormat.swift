//
//  String+Data.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation

extension String {
    func dateFormatter(with format: String = "dd/MM/yy") -> String {
        let dateFormatterGet = DateFormatter()
        let dateFormatterPrint = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint.dateFormat = format
        guard let date = dateFormatterGet.date(from: self) else {
            return ""
        }
        return dateFormatterPrint.string(from: date)
    }
}
