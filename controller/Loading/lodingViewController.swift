//
//  lodingViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import UIKit
import FSPagerView



class lodingViewController: UIViewController,FSPagerViewDelegate,FSPagerViewDataSource {
 
    
    let load = ["l1","l2","l3","l4","l5","l6"]
    
    @IBOutlet weak var views: FSPagerView!{
        didSet {
            views.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views.delegate = self
        views.layer.cornerRadius = 15
        
        let type = FSPagerViewTransformerType.depth
        views.transformer = FSPagerViewTransformer(type:type)
        views.decelerationDistance = FSPagerView.automaticDistance
        views.delegate = self
        views.backgroundColor = .clear
        views.dataSource = self
        views.automaticSlidingInterval = 1

        // Do any additional setup after loading the view.
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return load.count
    }
    func close() {
        dismiss(animated: false, completion: nil)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        let url = URL(string: Advertisement[index].image)
        cell.imageView?.image = UIImage(named: load[index], in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}

