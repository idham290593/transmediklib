//
//  DoctorInfoView.swift
//  Pasien
//
//  Created by Adam M Riyadi on 16/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class DoctorInfoView: UIView {
    
    var user: ConsultationUserModel?
    var date: Date?
    
    internal let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hexString: "#51C3C4").cgColor
        view.frame.size.width = 50
        view.frame.size.height = 50
        return view
    }()
    
    internal let profileName : UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Roboto-Regular", size: 14)
        //view.font = .boldSystemFont(ofSize: 14)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    internal let profileName2 : UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor(hexString: "#959393")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    internal let profileName3 : UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor(hexString: "#959393")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    internal let dateLabel : UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Roboto-Light", size: 12)
        view.textColor = UIColor(hexString: "#959393")
        return view
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .white
    }

    public convenience init(user: ConsultationUserModel?, date: Date?) {
        self.init(frame: .zero)
        self.user = user
        self.date = date
        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        initializeData()
        setupView()
    }
    
    internal func initializeData() {
        
        if (user?.profile_picture != nil) {
            profileImageView.kf.setImage(with: URL(string: (user?.profile_picture)!))
        }
        else {
            profileImageView.image = UIImage(named: "doctor-default", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }
        
        if (date != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy"
            let _date = dateFormatter.string(from: date!)
            
            dateLabel.text = _date
        }
        
        profileName.text = user?.full_name
        profileName2.text = "Dokter Umum"
        profileName3.text = "446/PD/0498/DPMPTSP-PPK/2019"
    }
    
    internal func setupView() {
        
        self.isUserInteractionEnabled = true
        
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
        profileName.sizeToFit()
        profileName2.sizeToFit()
        profileName3.sizeToFit()
        dateLabel.sizeToFit()
        
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor
            .constraint(equalTo:self.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor
            .constraint(equalTo:profileImageView.topAnchor).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        
        self.addSubview(profileName2)
        profileName2.translatesAutoresizingMaskIntoConstraints = false
        profileName2.topAnchor
            .constraint(equalTo:profileName.bottomAnchor, constant: 2).isActive = true
        profileName2.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        
        self.addSubview(profileName3)
        profileName3.translatesAutoresizingMaskIntoConstraints = false
        profileName3.topAnchor
            .constraint(equalTo:profileName2.bottomAnchor, constant: 2).isActive = true
        profileName3.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor
            .constraint(equalTo:profileImageView.topAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
}
