//
//  PremiumVC.swift
//  SwiftStitch
//
//  Created by nguyenhuyson on 11/25/20.
//  Copyright © 2020 ellipsis.com. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import GoogleMobileAds
import StoreKit
import MBProgressHUD

enum PurchaseType: Int {
    case weekly
    case monthly
    case yearly
}
class PremiumVC: UIViewController {
    
   
    var purchaseType: PurchaseType = .yearly
    var scale = DEVICE_WIDTH / 414
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblPremiun: UILabel!
    @IBOutlet weak var txtUnlimited: UITextView!
    @IBOutlet var listView: [UIView]!
    @IBOutlet var listlbl: [UILabel]!
    @IBOutlet weak var topView1: NSLayoutConstraint!

    @IBOutlet weak var topLblPremium: NSLayoutConstraint!
    @IBOutlet weak var topBtnBuy: NSLayoutConstraint!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var txtBottom: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewHeader.backgroundColor = .clear
        lblPremiun.font = lblPremiun.font.withSize(26 * scale)
        topLblPremium.constant = 30 * scale
        txtUnlimited.font = txtUnlimited.font?.withSize(32 * scale)
        topView1.constant = 39 * scale
        for lbl in listlbl {
            lbl.font = lbl.font.withSize(16 * scale)
        }
        for view in listView{
            view.layer.borderWidth = 1 * scale
            view.layer.borderColor = #colorLiteral(red: 0.6571614146, green: 0.6571771502, blue: 0.6571686864, alpha: 1)
            view.layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            view.layer.cornerRadius = 14 * scale
        }
        topBtnBuy.constant = 44 * scale
        btnBuy.layer.cornerRadius = 14 * scale
        btnRestore.layer.cornerRadius = 14 * scale
        txtBottom.font = txtBottom.font?.withSize(10 * scale)
        btnBuy.titleLabel?.font = txtBottom.font?.withSize(18 * scale)
        btnRestore.titleLabel?.font = txtBottom.font?.withSize(18 * scale)
        btnBack.layer.cornerRadius = 14 * scale
        btnBack.titleLabel?.font = txtBottom.font?.withSize(18 * scale)
    }
    
    
    
    func purchasePro(type: PurchaseType){
        var productId = PRODUCT_ID_YEARLY
        if type == .yearly {
            productId = PRODUCT_ID_YEARLY
        }
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let product):
                // fetch content from your server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                let interval = date.timeIntervalSince1970
                PaymentManager.shared.savePurchase(time: interval)
                print("Purchase Success: \(product.productId)")
                let fastCleanVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WelcomeVC.className) as! WelcomeVC
                self.navigationController?.pushViewController(fastCleanVC, animated: true)
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }

    @IBAction func ac_back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func ac_life(_ sender: Any) {
        purchaseType = .yearly
        self.purchasePro(type: .yearly)
    }
    
    @IBAction func ac_regist(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                let interval = date.timeIntervalSince1970
                PaymentManager.shared.savePurchase(time: interval)
//                print("Purchase Success: \(product.productId)")
                let fastCleanVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WelcomeVC.className) as! WelcomeVC
                self.navigationController?.pushViewController(fastCleanVC, animated: true)
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    

}
