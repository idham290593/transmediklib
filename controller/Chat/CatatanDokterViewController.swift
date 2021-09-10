//
//  CatatanDokterViewController.swift
//  Pasien
//
//  Created by Adam M Riyadi on 16/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CatatanDokterViewController: MYUIViewController {
    
    var consultation: ConsultationPostModel?
    var date: Date?
    
    var json: JSON?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "back", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil), for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let navigationTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.318, green: 0.765, blue: 0.769, alpha: 1)
        view.font = UIFont(name: "Roboto-Medium", size: 18)
        view.text = LocalizationHelper.getInstance()!.catatan_dokter
        return view
    }()
    //navigation
    
    private let doctorView: DoctorInfoView = {
        let view = DoctorInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let lineView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let subView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#D8DEE2").cgColor
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#D8DEE2").cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#D8DEE2").cgColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let label1_title: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.font = .boldSystemFont(ofSize: 14)
        view.font = UIFont(name: "Roboto-Regular", size: 14)
        return view
    }()
    
    private let label1_body: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 100
        return view
    }()
    
    private let label2_title: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.font = .boldSystemFont(ofSize: 14)
        view.font = UIFont(name: "Roboto-Regular", size: 14)
        return view
    }()
    
    private let label2_body: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 100
        return view
    }()
    
    private let label3_title: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.font = .boldSystemFont(ofSize: 14)
        view.font = UIFont(name: "Roboto-Regular", size: 14)
        return view
    }()
    
    private let label3_body: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 100
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        initializeDatas()
        setupSubViews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeDatas() {
        let spa = json!["spa"]
        var symptoms = spa["symptoms"].string
        symptoms = symptoms?.replacingOccurrences(of: "|", with: "\r\n")
        var possible_diagnosis = spa["possible_diagnosis"].string
        possible_diagnosis = possible_diagnosis?.replacingOccurrences(of: "|", with: "\r\n")
        var advice = spa["advice"].string
        advice = advice?.replacingOccurrences(of: "|", with: "\r\n")
        
        doctorView.user = consultation?.doctor
        doctorView.date = date
        
        label1_title.text = LocalizationHelper.getInstance()?.symptoms
        label1_body.text = symptoms
        
        label2_title.text = LocalizationHelper.getInstance()?.possible_diagnosis
        label2_body.text = possible_diagnosis
        
        label3_title.text = LocalizationHelper.getInstance()?.advice
        label3_body.text = advice
    }
    
    private func setupSubViews() {
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        backButton.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        view.addSubview(navigationTitle)
        navigationTitle.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 15).isActive = true
        navigationTitle.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        view.addSubview(doctorView)
        doctorView.topAnchor.constraint(equalTo: navigationTitle.bottomAnchor, constant: 20).isActive = true
        doctorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        doctorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        doctorView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: doctorView.bottomAnchor, constant: 5).isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        doctorView.layoutIfNeeded()
        view.layoutSubviews()
        
        var height = backButton.frame.height + doctorView.frame.height + lineView.frame.height + 20 + 20 + 5 + 15
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 15).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        //contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.width).isActive = true
        
        setupSubView1()
        setupSubView2()
        setupSubView3()
        contentView.layoutSubviews()
        
        height = subView1.frame.height + subView2.frame.height + subView3.frame.height + 5 + 15 + 15 + 20
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        scrollView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    func setupSubView1() {
        contentView.addSubview(subView1)
        subView1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        subView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        subView1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        subView1.addSubview(label1_title)
        label1_title.topAnchor.constraint(equalTo: subView1.topAnchor, constant: 15).isActive = true
        label1_title.leadingAnchor.constraint(equalTo: subView1.leadingAnchor, constant: 15).isActive = true
        label1_title.sizeToFit()
        
        subView1.addSubview(lineView1)
        lineView1.topAnchor.constraint(equalTo: label1_title.bottomAnchor, constant: 5).isActive = true
        lineView1.leadingAnchor.constraint(equalTo: subView1.leadingAnchor, constant: 15).isActive = true
        lineView1.trailingAnchor.constraint(equalTo: subView1.trailingAnchor, constant: -15).isActive = true
        lineView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        subView1.addSubview(label1_body)
        label1_body.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 5).isActive = true
        label1_body.leadingAnchor.constraint(equalTo: subView1.leadingAnchor, constant: 15).isActive = true
        label1_body.trailingAnchor.constraint(equalTo: subView1.trailingAnchor, constant: -15).isActive = true
        label1_body.sizeToFit()
        
        label1_body.bottomAnchor.constraint(equalTo: subView1.bottomAnchor, constant: -15).isActive = true
        subView1.heightAnchor.constraint(greaterThanOrEqualToConstant: label1_title.frame.height + label1_body.frame.height + 15 + 5 + 5 + 1 + 15).isActive = true
        
        subView1.layoutIfNeeded()
    }
    
    func setupSubView2() {
        contentView.addSubview(subView2)
        subView2.topAnchor.constraint(equalTo: subView1.bottomAnchor, constant: 15).isActive = true
        subView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        subView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        subView2.addSubview(label2_title)
        label2_title.topAnchor.constraint(equalTo: subView2.topAnchor, constant: 15).isActive = true
        label2_title.leadingAnchor.constraint(equalTo: subView2.leadingAnchor, constant: 15).isActive = true
        label2_title.sizeToFit()
        
        subView2.addSubview(lineView2)
        lineView2.topAnchor.constraint(equalTo: label2_title.bottomAnchor, constant: 5).isActive = true
        lineView2.leadingAnchor.constraint(equalTo: subView2.leadingAnchor, constant: 15).isActive = true
        lineView2.trailingAnchor.constraint(equalTo: subView2.trailingAnchor, constant: -15).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        subView2.addSubview(label2_body)
        label2_body.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 5).isActive = true
        label2_body.leadingAnchor.constraint(equalTo: subView2.leadingAnchor, constant: 15).isActive = true
        label2_body.trailingAnchor.constraint(equalTo: subView2.trailingAnchor, constant: -15).isActive = true
        label2_body.sizeToFit()
        
        label2_body.bottomAnchor.constraint(equalTo: subView2.bottomAnchor, constant: -15).isActive = true
        subView2.heightAnchor.constraint(greaterThanOrEqualToConstant: label2_title.frame.height + label2_body.frame.height + 15 + 5 + 5 + 1 + 15).isActive = true
        
        subView2.layoutIfNeeded()
    }
    
    func setupSubView3() {
        contentView.addSubview(subView3)
        subView3.topAnchor.constraint(equalTo: subView2.bottomAnchor, constant: 15).isActive = true
        subView3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        subView3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        subView3.addSubview(label3_title)
        label3_title.topAnchor.constraint(equalTo: subView3.topAnchor, constant: 15).isActive = true
        label3_title.leadingAnchor.constraint(equalTo: subView3.leadingAnchor, constant: 15).isActive = true
        label3_title.sizeToFit()
        
        subView3.addSubview(lineView3)
        lineView3.topAnchor.constraint(equalTo: label3_title.bottomAnchor, constant: 5).isActive = true
        lineView3.leadingAnchor.constraint(equalTo: subView3.leadingAnchor, constant: 15).isActive = true
        lineView3.trailingAnchor.constraint(equalTo: subView3.trailingAnchor, constant: -15).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        subView3.addSubview(label3_body)
        label3_body.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 5).isActive = true
        label3_body.leadingAnchor.constraint(equalTo: subView3.leadingAnchor, constant: 15).isActive = true
        label3_body.trailingAnchor.constraint(equalTo: subView3.trailingAnchor, constant: -15).isActive = true
        label3_body.sizeToFit()
        
        label3_body.bottomAnchor.constraint(equalTo: subView3.bottomAnchor, constant: -15).isActive = true
        subView3.heightAnchor.constraint(greaterThanOrEqualToConstant: label3_title.frame.height + label3_body.frame.height + 15 + 5 + 5 + 1 + 15).isActive = true
        
        subView3.layoutIfNeeded()
    }
    
    @objc func backBtnDidTap(){
        dismiss(animated: true, completion: nil)
    }
}
