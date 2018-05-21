//
//  ViewController.swift
//  QRCodeTimestamp
//
//  Created by Shawn Roller on 5/20/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var timer: Timer?
    var qrCodeImage: UIImage? {
        didSet {
            qrCodeImageView.image = qrCodeImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQRTimer()
    }
    
    private func startQRTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(generateQRCodeForCurrentTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func generateQRCodeForCurrentTime() {
        qrCodeImage = getQRCode(for: Date())
    }
    
    private func getQRCode(for date: Date) -> UIImage {
        let qrCode = QRCode("\(date)")
        print("\(String(data: qrCode!.data, encoding: .utf8) ?? "")")
        return qrCode?.image ?? UIImage()
    }

}

