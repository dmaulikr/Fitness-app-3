//
//  TypographyExtension.swift
//  Fitsta
//
//  Created by Jesse Cohen on 06/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit

extension UILabel{
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text!.characters.count))
        attributedText = attributedString
    }
}

extension UITextView{
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text!.characters.count))
        attributedString.addAttribute("\(self.font?.lineHeight)", value: 50, range: NSRange(location: 0, length: text!.characters.count))
        attributedText = attributedString
    }
    
//    func AddLineHeightAndTextSpacing(_ spacing: CGFloat, lineHeight: CGFloat) {
//        
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineSpacing = 7
//        paragraph.lineHeightMultiple = lineHeight
//        paragraph.maximumLineHeight  = lineHeight
//        paragraph.minimumLineHeight  = lineHeight
//        
//        let ats = [NSFontAttributeName: UIFont(name: "BrixtonLight", size: 16.0)!, NSParagraphStyleAttributeName: paragraph, NSKernAttributeName: spacing] as [String : Any]
//        self.attributedText = NSAttributedString(string: self.text, attributes: ats)
//        
//    }
    
}

extension UIButton{
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UITextField {
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.text!))
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text!.characters.count))
        attributedText = attributedString
    }
    
}
