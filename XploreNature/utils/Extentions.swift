//
//  Extentions.swift
//  xploreNature
//
//  Created by user196210 on 6/30/21.
//

import Foundation
import UIKit
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }
    
    func getTodayString() -> String!{
        var today_string = ""
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        today_string = String(year!) + "-" + zeroLeadStrNum(num: month!) + "-" + zeroLeadStrNum(num: day!) + " " + zeroLeadStrNum(num: hour!)  + ":" + zeroLeadStrNum(num: minute!)
        return today_string
    }
    
    func stringToDate(strDate: String) -> Date? {
        // Debug: check if works correctly
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'yyyy'-'MM'-'dd' T'HH':'mm'"
        return dateFormatter.date(from: strDate)
    }
    
    private func zeroLeadStrNum(num : Int) -> String{
        if(num>9) {
            return String(num)
        } else {
            return String("0\(num)")
        }
    }
}

extension String {
    var length: Int { return self.count }
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension UIImageView {
    func downloaded(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    self.image = UIImage(data: data)
                }
            }
        task.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
