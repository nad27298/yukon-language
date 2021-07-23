//
//  CategoryVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit
import SQLite
import GoogleMobileAds
import FBAudienceNetwork

class CategoryVC: UIViewController {
    
    @IBOutlet weak var heightSet: NSLayoutConstraint!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var heightS: NSLayoutConstraint!
    @IBOutlet weak var leadSearch: NSLayoutConstraint!
    @IBOutlet weak var leadImg: NSLayoutConstraint!
    @IBOutlet weak var topCLV: NSLayoutConstraint!
    @IBOutlet weak var trailingBtn: NSLayoutConstraint!
    @IBOutlet weak var leadViewSearch: NSLayoutConstraint!
    @IBOutlet weak var topviewSearch: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txfldSearch: UITextField!
    @IBOutlet weak var clcViewCategory: UICollectionView!
    @IBOutlet weak var imgSearch: UIImageView!
    
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    var categoryData: [CategoryModel] = []
    var txtfldData: [CategoryModel] = []
    var isSearching: Bool = false
    var filterString: String = ""
    var scale = DEVICE_WIDTH / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewSearch)
        clcViewCategory.delegate = self
        clcViewCategory.dataSource = self
        clcViewCategory.register(UINib(nibName: "CategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryCVC")
        clcViewCategory.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nativeAdmobCLVCell.className)
        viewSearch.layer.cornerRadius = 30 * scale
        clcViewCategory.layer.cornerRadius = 10 * scale
        categoryData = CategoryEntity.shared.getData()
        scaleToFill()
        print(LanguageEntity.shared.languageDefaulCode())
        AdmobManager.shared.loadBannerView(inVC: self)
        AdmobManager.shared.loadAllNativeAds()
        txfldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func textFieldDidChange (_ sender: UITapGestureRecognizer) {
        txtfldData = []
        if txfldSearch.text == "" {
            self.isSearching = false
        } else {
            self.isSearching = true
            //            filterString = textField.text!
            for item in CategoryEntity.shared.getData() {
                if item.title.lowercased().contains((txfldSearch.text!.lowercased())){
                    txtfldData.append(item)
                }
            }
        }
        self.clcViewCategory.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clcViewCategory.reloadData()
        if PaymentManager.shared.isPurchase() {
            if fbNativeAds != nil{
                fbNativeAds = nil
                clcViewCategory.reloadData()
            }
            if admobNativeAds != nil{
                admobNativeAds = nil
                clcViewCategory.reloadData()
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
                clcViewCategory.reloadData()
            }
        }
    }
    
    
    func scaleToFill() {
        topviewSearch.constant = 48 * scale
        leadViewSearch.constant = 32 * scale
        trailingBtn.constant = 31 * scale
        topCLV.constant = 16 * scale
        leadImg.constant = 20 * scale
        leadSearch.constant = 20 * scale
        heightS.constant = 56 * scale
        txfldSearch.font = txfldSearch.font?.withSize(16 * scale)
        heightSet.constant = 40 * scale
    }
    
    @IBAction func btn_Setting(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setting:SettingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        setting.onComplete = { [weak self] in
            self?.clcViewCategory.reloadData()
        }
        self.present(setting, animated: true)
    }
    
}


extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching == false {
            return categoryData.count
        } else {
            return txtfldData.count
        }
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
    
    func loadCollectionView(_ data: [CategoryModel],_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CategoryCVC = clcViewCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10 * scale
        cell.imgZoom.image = UIImage(named: "Zoom In")
        cell.lblTitle.text = data[indexPath.row].title
        cell.imgHinh.image = UIImage(named: data[indexPath.row].image)
        cell.lblNote.text = data[indexPath.row].locaziation()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching == false {
            return loadCollectionView(categoryData, indexPath)
        } else {
            return loadCollectionView(txtfldData, indexPath)
        }
    }
    
    func getScreen(_ data: [CategoryModel],_ indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let items:ItemsVC = storyboard.instantiateViewController(withIdentifier: "ItemsVC") as! ItemsVC
        items.checkId = data[indexPath.row].id
        items.name = data[indexPath.row].title
        self.present(items, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearching == false {
            getScreen(categoryData, indexPath)
        } else {
            getScreen(txtfldData, indexPath)
        }
    }
    
}

extension CategoryVC: UICollectionViewDelegateFlowLayout {
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


