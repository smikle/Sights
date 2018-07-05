//
//  DPrint.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let printDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        
        return formatter
    }()
}

#if DEBUG
func dPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", filePath: String = #file, function: String = #function, line: Int = #line) {
    let fileName = ((filePath as NSString).lastPathComponent as NSString).deletingPathExtension
    NSLog("\(DateFormatter.printDateFormatter.string(from: Date())) [\(fileName):\(line)] \(function) - \(items[0])")
}
#else
func dPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", filePath: String = #file, function: String = #function, line: Int = #line) {
}
#endif
