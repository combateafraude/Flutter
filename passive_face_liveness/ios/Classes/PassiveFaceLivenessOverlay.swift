//
//  PassiveFaceLivenessOverlay.swift
//  _AppDemo
//
//  Created by Daniel Seitenfus on 20/10/21.
//  Copyright © 2021 Combate à Fraude. All rights reserved.
//

import Foundation
import PassiveFaceLiveness
import UIKit

class PassiveFaceLivenessOverlay: PassiveOverlayView {
    var bundle :Bundle!
    var faceMaskImage: UIImageView = UIImageView()
    var viewText: UIView = UIView()
    var lblText: UILabel = UILabel()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var imgTriangle: UIImageView!
    
    var btnManualCapture: UIButton = UIButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        bundle = Bundle(for: type(of: self))
        self.setupComponents(frame: frame)
    }
    
    private func setupComponents(frame: CGRect){
        self.faceMaskImage = UIImageView(frame: frame)
        faceMaskImage.image = UIImage(named: "mask_white")
        faceMaskImage.contentMode = .scaleAspectFill
        self.addSubview(faceMaskImage)
        
        // 70% of screen height + 5 for space
        let posY = (frame.size.height * 70 / 100) + 5
        let posX = (frame.width / 2) - 12
        
        // status text
        self.imgTriangle = UIImageView(frame: CGRect(x: posX , y: posY, width: 25, height: 12))
        self.imgTriangle.image = UIImage(named: "triangle", in: bundle, compatibleWith: nil )
        self.imgTriangle.contentMode = .scaleAspectFit
        self.addSubview(self.imgTriangle)
        
        // manual capture button
        self.btnManualCapture = UIButton(frame: CGRect(x: ((frame.width / 2) - 25) , y: (frame.size.height * 70 / 100)+10, width: 50, height: 50))
        self.btnManualCapture.addTarget(self, action:#selector(self.manualButtonClicked), for: .touchUpInside)
        self.btnManualCapture.contentMode = .scaleAspectFit
        self.btnManualCapture.setImage(UIImage(named: "camera_icon", in: bundle, compatibleWith: nil ), for: .normal)
        self.btnManualCapture.backgroundColor = .cyan
        self.btnManualCapture.layer.cornerRadius = 0.5 * self.btnManualCapture.bounds.size.width
        self.btnManualCapture.clipsToBounds = true
        self.addSubview(self.btnManualCapture)
        
        self.viewText = UIView(frame: CGRect(x: CGFloat(20), y: posY + self.imgTriangle.frame.height - 1, width: frame.width - CGFloat(20) - CGFloat(20), height: 40))
        self.viewText.backgroundColor = UIColor.white
        self.viewText.layer.cornerRadius = 8
        self.addSubview(self.viewText)
        
        self.lblText = UILabel(frame: CGRect(x: 0, y: 0, width: self.viewText.frame.width, height: self.viewText.frame.height))
        self.lblText.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
        self.lblText.textAlignment = .center
        self.lblText.font = UIFont.boldSystemFont(ofSize: 18)
        self.viewText.addSubview(self.lblText)
        
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
    
    @objc func cancelButtonClick(sender: UIButton!) {
        self.viewController?.cancelButtonClick()
    }
    
    override func show(manualCaptureButton hidden: Bool){
        btnManualCapture.isHidden = hidden
    }
    
    override func showMessage(message: String) {
        DispatchQueue.main.async {
            self.lblText.text = message
            
            if(message.count > 0){
                self.viewText.isHidden = false
                self.imgTriangle.isHidden = false
            }else{
                self.viewText.isHidden = true
                self.imgTriangle.isHidden = true
            }
        }
    }
    
    
    override func showMask(type: MaskType) {
        switch type {
        case .normal:
            faceMaskImage.image = UIImage(named: "mask_white")
            break
        case .success:
            faceMaskImage.image = UIImage(named: "mask_green")
            break
        case .error:
            faceMaskImage.image = UIImage(named: "mask_red")
            break
        default:
            faceMaskImage.image = UIImage(named: "mask_white")
        }
    }
    
    override func showLoading(show: Bool){
        DispatchQueue.main.async {
            if(show){
                self.indicator.startAnimating()
            }else{
                self.indicator.stopAnimating();
            }
        }
    }
}
