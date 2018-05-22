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

    let key: Array<UInt8> = Array("thisisakeythisisakeythisisakeyth".utf8)
    let iv: Array<UInt8> = Array("drowssapdrowssap".utf8)
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
        guard let qrCode = QRCode(text) else { return UIImage() }
        let encrypted = "\(String(data: qrCode.data, encoding: .utf8) ?? "")"
        let decrypted = getDecryptedString(from: encrypted)
        
        print(" Encrypted String: \(encrypted)")
        print("Descrypted String: \(decrypted)")
        
        return qrCode.image ?? UIImage()
    }
    
    private func getEncryptedString(from date: Date) -> String {
        let input: Array<UInt8> = Array("\(date)".utf8)
        var cipherText = ""
        do {
            cipherText = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(input).toBase64() ?? ""
        }
        catch {
            print(error)
        }
        return cipherText
    }
    
    private func getDecryptedString(from text: String) -> String {
        guard let input = Data(base64Encoded: text) else { return "" }
        var plainText = ""
        do {
            let plainBytes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(input.bytes)
            plainText = String(bytes: plainBytes, encoding: .utf8) ?? ""
        }
        catch {
            print(error)
        }
        return plainText
    }

}

