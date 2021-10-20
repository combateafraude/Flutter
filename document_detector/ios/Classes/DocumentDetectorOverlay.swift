//
//  Teste.swift
//  _AppDemo
//
//  Created by Daniel Seitenfus on 19/10/21.
//  Copyright © 2021 Combate à Fraude. All rights reserved.
//

import Foundation
import DocumentDetector
import UIKit

class DocumentDetectorOverlay: DocumentOverlayView  {
    
    var documentMaskImage: UIImageView = UIImageView()
    var imgTriangle: UIImageView!
    var viewText: UIView = UIView()
    var lblText: UILabel = UILabel()
    var btnManualCapture: UIButton = UIButton()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var bundle: Bundle!
        
    override init() {
        super.init()
        self.setupComponents(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents(frame: CGRect){
        self.bundle = Bundle(for: type(of: self))
        self.documentMaskImage = UIImageView(frame: frame)
        self.documentMaskImage.image = UIImage(named: "mask_document_white")
        self.documentMaskImage.contentMode = .scaleAspectFill
        self.addSubview(documentMaskImage)
        
        // 78% of screen height + 5 for space
        let posY = (frame.size.height * 78 / 100) + 5
        let posX = (frame.width / 2) - 12
        
        // status text
        self.imgTriangle = UIImageView(frame: CGRect(x: posX , y: posY, width: 25, height: 12))
        self.imgTriangle.image = UIImage(named: "triangle", in: bundle, compatibleWith: nil )
        self.imgTriangle.contentMode = .scaleAspectFit
        self.addSubview(self.imgTriangle)
        
        // manual capture button
        self.btnManualCapture = UIButton(frame: CGRect(x: ((frame.width / 2) - 25) , y: (frame.size.height * 78 / 100)+10, width: 50, height: 50))
        self.btnManualCapture.addTarget(self, action:#selector(self.manualButtonClicked), for: .touchUpInside)
        self.btnManualCapture.contentMode = .scaleAspectFit
        self.btnManualCapture.setImage(UIImage(named: "camera_icon", in: bundle, compatibleWith: nil ), for: .normal)
        self.btnManualCapture.backgroundColor = .red
        self.btnManualCapture.layer.cornerRadius = 0.5 * self.btnManualCapture.bounds.size.width
        self.btnManualCapture.clipsToBounds = true
        self.addSubview(self.btnManualCapture)
        
        self.viewText = UIView()
        self.viewText.backgroundColor = UIColor.white
        self.viewText.layer.cornerRadius = 8
        self.addSubview(self.viewText)
        
        self.viewText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.viewText, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgTriangle, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -1).isActive = true
        
        NSLayoutConstraint(item: self.viewText, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: CGFloat(20)).isActive = true
               
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewText, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: CGFloat(20)).isActive = true
        
        self.lblText = UILabel()
        self.lblText.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0) //UIColor.init(red: 244/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.lblText.textAlignment = .center
        self.lblText.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.lblText.numberOfLines = 0
        self.lblText.adjustsFontSizeToFitWidth = false
        self.lblText.lineBreakMode = .byWordWrapping
        self.viewText.addSubview(self.lblText)
        
        self.lblText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.lblText, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewText, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 4).isActive = true
        
        NSLayoutConstraint(item: self.lblText, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewText, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 4).isActive = true
        
        NSLayoutConstraint(item: viewText, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.lblText, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 4).isActive = true
        
        NSLayoutConstraint(item: self.viewText, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lblText, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 4).isActive = true
        
        
        // loading indicator
        self.indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.indicator.center = self.center
        self.indicator.hidesWhenStopped = true
        self.indicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.addSubview(self.indicator)
        
        //set visibility
        self.btnManualCapture.isHidden = true
        self.viewText.isHidden = false
        self.imgTriangle.isHidden = false
    }
    
    @objc func manualButtonClicked(sender: UIButton!) {
        self.viewController?.clickButtonManualCapture()
    }
    
    public override func show(loading show: Bool) {
        if(show){
            DispatchQueue.main.async {
                self.indicator.startAnimating()
            }
        }else{
            DispatchQueue.main.async {
                self.indicator.stopAnimating();
            }
            
        }
    }
    
    public override func show(message text: String) {
        DispatchQueue.main.async {
            self.lblText.text = text
            
            if(text.count > 0){
                self.viewText.isHidden = false
                self.imgTriangle.isHidden = false
            }else{
                self.viewText.isHidden = true
                self.imgTriangle.isHidden = true
                
            }
        }
    }
    
    public override func show(mask type: MaskType) {
        switch type {
        case .success:
            documentMaskImage.image = UIImage(named: "mask_document_green")
            break;
        case .error:
            documentMaskImage.image = UIImage(named: "mask_document_red")
            break;
        case .normal:
            documentMaskImage.image = UIImage(named: "mask_document_white")
            break;
        default:
            documentMaskImage.image = UIImage(named: "mask_document_white")
            break;
        }
    }
    
    public override func show(manualCaptureButton hidden: Bool) {
        self.btnManualCapture.isHidden = hidden
    }
    
}
