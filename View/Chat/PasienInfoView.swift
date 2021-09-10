//
//  PasienInfoView.swift
//  Pasien
//
//  Created by Adam M Riyadi on 16/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class PasienInfoView: DoctorInfoView {
    
    
    internal let titleView : UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Roboto-Light", size: 15)
        view.contentMode = .scaleAspectFit
        view.text = LocalizationHelper.getInstance()?.data_pasien
        return view
    }()
    
    
    override func layoutSubviews() {
        initializeData()
        setupView()
    }
    
    override internal func initializeData() {
        
        if (user?.profile_picture != nil) {
            profileImageView.kf.setImage(with: URL(string: (user?.profile_picture)!))
        }
        else {
            profileImageView.image = UIImage(named: "patient-default", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }
        
        dateLabel.isHidden = true
        profileName3.isHidden = true
        
        profileName.text = user?.full_name
        profileName2.text = "20 Tahun"
    }
    
    override internal func setupView() {
        
        self.isUserInteractionEnabled = true
        
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
        titleView.sizeToFit()
        profileName.sizeToFit()
        profileName2.sizeToFit()
        dateLabel.sizeToFit()
        
        self.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor
            .constraint(equalTo:self.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor
            .constraint(equalTo:titleView.bottomAnchor, constant: 7).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor
            .constraint(equalTo:profileImageView.topAnchor, constant: 7).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        
        self.addSubview(profileName2)
        profileName2.translatesAutoresizingMaskIntoConstraints = false
        profileName2.topAnchor
            .constraint(equalTo:profileName.bottomAnchor, constant: 2).isActive = true
        profileName2.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        
    }
}
