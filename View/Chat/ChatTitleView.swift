//
//  ChatTitleView.swift
//  Pasien
//
//  Created by Adam M Riyadi on 13/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class ChatTitleView: UIView {
    
    var close = false{
        didSet{
         
            videoCallButton.isHidden = close
            endChatButton.isHidden = close
        }
    }
    public var backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "back", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil), for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hexString: "#51C3C4").cgColor
        view.frame.size.width = 40
        view.frame.size.height = 40
        return view
    }()
    

    let profileName : UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Roboto-Regular", size: 14)
        view.numberOfLines = 2
        return view
    }()
    let endChatButton = UIImageView(image: UIImage(named: "Sub Menu", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil))
    let videoCallButton = UIImageView(image: UIImage(named: "Videocall", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil))
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(frame: frame)
    }

    public convenience init() {
        self.init(frame: .zero)
        setupView(frame: .zero)
    }
    
    private func setupView(frame: CGRect) {
        let _width = frame.width + (-1 * frame.minX * 2)
        let _height = frame.height + (-1 * frame.minY * 2)
        print("tinggi")
        print(_height)
        self.isUserInteractionEnabled = true
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
//        endChatButton.backgroundColor = .blue
//        videoCallButton.backgroundColor = .red
        self.addSubview(backButton)
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: frame.minY).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        endChatButton.contentMode = .scaleAspectFit
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor
            .constraint(equalTo:self.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let onlineCircle : UIView = {
            let view = UIView()
            view.frame.size.height = 12
            view.clipsToBounds = true
            view.frame.size.width = 12
            view.layer.cornerRadius = 6
            view.backgroundColor = UIColor(hexString: "#48DF01")
            return view
        }()
        self.addSubview(onlineCircle)
        onlineCircle.translatesAutoresizingMaskIntoConstraints = false
        onlineCircle.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 3).isActive = true
        onlineCircle.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -10).isActive = true
        onlineCircle.widthAnchor.constraint(equalToConstant:12).isActive = true
        onlineCircle.heightAnchor.constraint(equalToConstant:12).isActive = true
        
        self.addSubview(endChatButton)
        endChatButton.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        endChatButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
//        self.addSubview(videoCallButton)
//        videoCallButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        endChatButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        videoCallButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        endChatButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

//        videoCallButton.translatesAutoresizingMaskIntoConstraints = false
        endChatButton.translatesAutoresizingMaskIntoConstraints = false

//        videoCallButton.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
//        videoCallButton.rightAnchor.constraint(equalTo: self.endChatButton.leftAnchor, constant: -10).isActive = true

        self.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.centerYAnchor
            .constraint(equalTo:self.centerYAnchor).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        profileName.trailingAnchor.constraint(lessThanOrEqualTo: endChatButton.leadingAnchor, constant: -10).isActive = true
        
//        self.addSubview(exchat)
//
//        exchat.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
//        exchat.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        exchat.leftAnchor.constraint(equalTo: self.leftAnchor,constant: -18 ).isActive = true
//        exchat.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        exchat.translatesAutoresizingMaskIntoConstraints = false
//        exchat.iconuper.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setinformation)))

        self.widthAnchor.constraint(equalToConstant: _width).isActive = true
        self.heightAnchor.constraint(equalToConstant: _height).isActive = true
//        self.bringSubviewToFront(backButton)
        self.bringSubview(toFront: backButton)
        
        
        
//        shareinfopatient = ExChat(frame: CGRect(x: 0.0, y: AppSettings.NAVIGATIONBAR_HEIGHT, width: bounds.width, height: CGFloat(160)))
//
//        self.view.addSubview(shareinfopatient)
    }
    
//    @objc func setinformation(){
//        if exchat.isopen{
//            closeinfo()
//        }else{
//            openinfo()
//        }
//    }
//
//    func closeinfo(){
//        if !exchat.ischangeopen{
//            return
//        }
//        exchat.ischangeopen = false
//
//        exchat.viewinfo.isHidden = true
//        UIView.animate(withDuration : 0.3){
//            self.exchat.tinggiinfo.constant = CGFloat(0)
//            self.exchat.layoutIfNeeded()
////            self.shareinfopatient.heightAnchor.constraint(equalToConstant: 40).isActive = true
////            self.view.layoutIfNeeded()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//            self.exchat.iconuper.image = UIImage(systemName: "arrow.down")
//            self.exchat.ischangeopen = true
//        }
//        exchat.isopen = false
//
//    }
//
//
//     func openinfo(){
//        if !exchat.ischangeopen{
//            return
//        }
//        exchat.ischangeopen = false
//        UIView.animate(withDuration : 0.3){
//            self.exchat.tinggiinfo.constant = CGFloat(120)
//            self.exchat.layoutIfNeeded()
//
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//            self.exchat.viewinfo.isHidden = false
//            self.exchat.iconuper.image = UIImage(systemName: "arrow.up")
//            self.exchat.ischangeopen = true
//        }
//
//        exchat.isopen = true
//    }
}
