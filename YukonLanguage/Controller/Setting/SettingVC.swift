//
//  SettingVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit
import StoreKit
import GoogleMobileAds
import FBAudienceNetwork

class SettingVC: UIViewController {
    
    @IBOutlet weak var heightViewL: NSLayoutConstraint!
    @IBOutlet weak var heightRate: NSLayoutConstraint!
    @IBOutlet weak var topSetting: NSLayoutConstraint!
    @IBOutlet weak var topCLV: NSLayoutConstraint!
    @IBOutlet weak var topViewL: NSLayoutConstraint!
    @IBOutlet weak var topBtn: NSLayoutConstraint!
    @IBOutlet weak var leadBtn: NSLayoutConstraint!
    @IBOutlet weak var lblSwitch: UILabel!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var trailingBtn: NSLayoutConstraint!
    @IBOutlet weak var leadText: NSLayoutConstraint!
    @IBOutlet weak var clcViewSetting: UICollectionView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var viewLanguage: UIView!
    var onComplete: (() -> ())?
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    var checkHiden: Int = 0
    var arrName: [String] = ["English", "Japan", "China", "Korea", "France", "Germany", "India", "Italy", "Russia", "Portugal", "Netherlands", "Poland", "Vietnam", "Nauy", "Slovenia", "Turkey", "Saudi Arabia", "Greece", "Kazakhstan", "Somail", "Haiti", "Swahili"]
    var arrLogo: [String] = ["english_logo", "japan_logo", "china_logo", "korea_logo", "france_logo", "germany_logo", "india_logo", "italy_logo", "russia_logo", "portugal_logo", "netherlands_logo", "poland_logo", "vietnam_logo", "nauy_logo", "slovenia_logo", "turkey_logo", "arabia_logo", "greece_logo", "kazakhstan_logo", "somail_logo", "haiti_logo", "swahili_logo"]
    var arrCode: [String] = ["en", "ja", "zh", "ko", "fr", "de", "hi", "it", "ru", "pt", "nl", "pl", "vi", "no", "sl", "tr", "ar", "el", "kk", "so", "ht", "sw"]
    var scale = DEVICE_WIDTH / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewLanguage)
        viewLanguage.layer.cornerRadius = 10
        btnRate.layer.cornerRadius = 10
        clcViewSetting.layer.cornerRadius = 10
        clcViewSetting.dataSource = self
        clcViewSetting.delegate = self
        clcViewSetting.register(UINib(nibName: "SettingCVC", bundle: nil), forCellWithReuseIdentifier: "SettingCVC")
        clcViewSetting.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nativeAdmobCLVCell.className)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewLanguage.addGestureRecognizer(tap)
        scaleToFill()
        if checkHiden % 2 == 0 {
            clcViewSetting.isHidden = true
        } else {
            clcViewSetting.isHidden = false
        }
    }
    
    func scaleToFill() {
        leadText.constant = 10 * scale
        trailingBtn.constant = 20 * scale
        leadBtn.constant = 32 * scale
        topBtn.constant = 32 * scale
        topViewL.constant = 20 * scale
        topCLV.constant = 12 * scale
        topSetting.constant = 66 * scale
        lblSetting.font = lblSetting.font.withSize(20 * scale)
        lblSwitch.font = lblSwitch.font.withSize(16 * scale)
        btnRate.titleLabel?.font = UIFont(name: "Thonburi Bold", size: 16 * scale)
        heightRate.constant = 41 * scale
        heightViewL.constant = 41 * scale
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if PaymentManager.shared.isPurchase() {
            if fbNativeAds != nil{
                fbNativeAds = nil
                clcViewSetting.reloadData()
            }
            if admobNativeAds != nil{
                admobNativeAds = nil
                clcViewSetting.reloadData()
            }
        }else{
            if let native = AdmobManager.shared.randoomNativeAds(){
                if native is FBNativeAd{
                    fbNativeAds = native as? FBNativeAd
                    admobNativeAds = nil
                }else{
                    admobNativeAds = native as? GADUnifiedNativeAd
                    fbNativeAds = nil
                }
                clcViewSetting.reloadData()
            }
        }
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Rate(_ sender: Any) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if PaymentManager.shared.isPurchase() {
            self.checkHiden += 1
            if checkHiden % 2 == 0 {
                clcViewSetting.isHidden = true
            } else {
                clcViewSetting.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                let premium = self.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                self.present(premium, animated: true, completion: nil)
            }
        }
    }
    
}

extension SettingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nativeAdmobCLVCell.className, for: indexPath) as! nativeAdmobCLVCell
            if let native = self.admobNativeAds {
                headerView.backgroundColor = .clear
                headerView.setupHeader(nativeAd: native)
            }
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if fbNativeAds == nil && admobNativeAds == nil{
            return CGSize(width: DEVICE_WIDTH, height: 0)
        }
        return CGSize(width: DEVICE_WIDTH, height: 160 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCVC", for: indexPath) as! SettingCVC
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.lblName.text = arrName[indexPath.row]
        cell.imgLogo.image = UIImage(named: arrLogo[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = LanguageEntity.shared.updateLanguage(code: self.arrCode[indexPath.row].lowercased(), isSelected: "true")
        onComplete?()
        self.dismiss(animated: true)
    }
    
}

extension SettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 344 * scale, height: 78 * scale)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15 * scale, left: 10 * scale, bottom: 15 * scale, right: 10 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 * scale
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
