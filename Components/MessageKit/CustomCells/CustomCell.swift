/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageKit

open class CustomCell: UICollectionViewCell {
    
    let subView = UIView()
    let label = UITextView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews() {
        contentView.addSubview(subView)
        
        subView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -5).isActive = true
        label.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        label.textAlignment = .center
        label.backgroundColor = UIColor(hexString: "#EAF0F4")
        label.textColor = UIColor(hexString: "#959393")
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.layer.cornerRadius = 15
        label.isScrollEnabled = false
        label.textContainerInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        subView.frame = contentView.bounds
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        // Do stuff
        switch message.kind {
        case .custom(let data):
            guard let systemMessage = data as? String else { return }
            label.text = systemMessage
        case .text(let data):
            label.text = data
        case .attributedText(let data):
            label.text = data.string
        default:
            break
        }
        label.sizeToFit()
        subView.setNeedsLayout()
        subView.layoutIfNeeded()
    }
    
}
