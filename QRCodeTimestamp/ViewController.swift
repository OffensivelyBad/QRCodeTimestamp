//
//  ViewController.swift
//  QRCodeTimestamp
//
//  Created by Shawn Roller on 5/20/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import CryptoSwift

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
        let cipherText = getEncryptedString(from: Date())
        qrCodeImage = getQRCode(for: cipherText)
    }
    
    private func getQRCode(for text: String) -> UIImage {
        let qrCode = QRCode(text)
        let encrypted = "\(String(data: qrCode!.data, encoding: .utf8) ?? "")"
        print(encrypted)
        let decrypted = getDecryptedString(from: encrypted)
        print(decrypted)
        return qrCode?.image ?? UIImage()
    }
    
    private func getEncryptedString(from date: Date) -> String {
        var cipherText = ""
        do {
            let aes = try AES(key: "thisisakeythisisakeythisisakeyth", iv: "drowssapdrowssap")
            cipherText = try aes.encrypt(Array("\(date)".utf8)).toHexString()
        }
        catch {
            
        }
        return cipherText
    }
    
    private func getDecryptedString(from text: String) -> String {
        var plainText = ""
        do {
            let aes = try AES(key: "thisisakeythisisakeythisisakeyth", iv: "drowssapdrowssap")
            plainText = try aes.decrypt(Array("\(text)".utf8)).toHexString()
        }
        catch {
            
        }
        return plainText
    }

}

