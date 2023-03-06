//
//  String++.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 04.08.22.
//

import UIKit

extension String {
    func htmlAttributedString(size: CGFloat, color: UIColor) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                color: \(color.hexString!);
                font-family: -apple-system;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            \(self.replacingOccurrences(of: "href=\"/p/", with: "href=\"https://pastvu.com/p/"))
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .windowsCP1251) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.windowsCP1251.rawValue],
            documentAttributes: nil
        ) else {
            return nil
        }
        return attributedString
    }
    
    var pastvuURL: URL? {
        guard let baseUrl = URL(string: "https://pastvu.com/_p/d/") else { return nil }
        return baseUrl.appendingPathComponent(self)
    }
}


