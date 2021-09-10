//
//  Htmltostring.swift
//  Pasien
//
//  Created by Idham on 04/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
extension NSAttributedString {
     internal convenience init?(html: String) {
         guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
             // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
             return nil
         }
         guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
             return nil
         }
         self.init(attributedString: attributedString)
     }
 }
//label.attributedText = NSAttributedString(html: "<span> recognized <a href='#/userProfile/NZ==/XQ=='> Punit Kumar </a> for Delivers on time</span>")

