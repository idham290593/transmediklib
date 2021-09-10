//
//  cellvaluepertanyaanTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit

class cellvaluepertanyaanTableViewCell: UITableViewCell {

    
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var isselected: UIImageView!
    @IBOutlet weak var values: UILabel!
    var delegate : getheightrow?
    var row:Int?
    var ischeck = false{
        didSet{
            if ischeck{
                if radio{

                    isselected.image = UIImage(named: "Radio Button Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                }else{
                    isselected.image = UIImage(named: "Checkbox Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)

                }
            }else{
                if radio{
                    isselected.image = UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                    
                }else{
                    isselected.image = UIImage(named: "Checkbox", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                   
                }
            }
        }
    }
    var radio = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isselected.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checked)))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.getrow(value: self.views.frame.height)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func checked(){
        ischeck = !ischeck
        delegate?.selectedrow(row: row!, label: values.text ?? "" ,value: ischeck)
        
    }
}
