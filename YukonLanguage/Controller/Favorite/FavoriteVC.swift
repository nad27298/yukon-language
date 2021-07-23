//
//  FavoriteVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork

class FavoriteVC: UIViewController, SmartDelegate {
    
    @IBOutlet weak var btnBackOut: UIButton!
    @IBOutlet weak var heightS: NSLayoutConstraint!
    @IBOutlet weak var trailImgC: NSLayoutConstraint!
    @IBOutlet weak var leadImgC: NSLayoutConstraint!
    @IBOutlet weak var trailSC: NSLayoutConstraint!
    @IBOutlet weak var topFavC: NSLayoutConstraint!
    @IBOutlet weak var leadVSC: NSLayoutConstraint!
    @IBOutlet weak var leadBackC: NSLayoutConstraint!
    @IBOutlet weak var topBackC: NSLayoutConstraint!
    @IBOutlet weak var clcViewFavorite: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    var faveriteData: [ItemsModel] = []
    var checkFavorite: Int = 0
    var txtfldData: [ItemsModel] = []
    var isSearching: Bool = false
    
    var scale = DEVICE_WIDTH / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewSearch)
        btnSearch.isHidden = true
        faveriteData = ItemsEntity.shared.getFavData()
        btnBackOut.isHidden = true
        viewSearch.layer.cornerRadius = 30 * scale
        clcViewFavorite.layer.cornerRadius = 10 * scale
        viewSearch.isHidden = true
        clcViewFavorite.delegate = self
        clcViewFavorite.dataSource = self
        clcViewFavorite.register(UINib(nibName: "FavoriteCVC", bundle: nil), forCellWithReuseIdentifier: "FavoriteCVC")
        clcViewFavorite.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nativeAdmobCLVCell.className)
        clcViewFavorite.reloadData()
        txtFldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        scaleToFill()
        AdmobManager.shared.loadBannerView(inVC: self)
        AdmobManager.shared.loadAllNativeAds()
        self.hideKeyboardWhenTappedAround()
    }
    
    func updateAnswer() {
        self.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        faveriteData = ItemsEntity.shared.getFavData()
        self.clcViewFavorite.reloadData()
        if PaymentManager.shared.isPurchase() {
            if fbNativeAds != nil{
                fbNativeAds = nil
                clcViewFavorite.reloadData()
            }
            if admobNativeAds != nil{
                admobNativeAds = nil
                clcViewFavorite.reloadData()
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
                clcViewFavorite.reloadData()
            }
        }
    }
    
    func scaleToFill() {
        lblName.font = lblName.font.withSize(20 * scale)
        topBackC.constant = 61 * scale
        leadBackC.constant = 32 * scale
        leadVSC.constant = 83 * scale
        topFavC.constant = 16 * scale
        trailSC.constant = 31 * scale
        leadImgC.constant = 20 * scale
        trailImgC.constant = 10 * scale
        heightS.constant = 56 * scale
        txtFldSearch.font = txtFldSearch.font?.withSize(16 * scale)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabbar: TabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        self.present(tabbar, animated: false, completion: nil)
    }
    
    @IBAction func btn_Search(_ sender: Any) {
//        viewSearch.isHidden = false
//        lblName.isHidden = true
//        btnSearch.isHidden = true
    }
    
    @objc func textFieldDidChange (_ sender: UITapGestureRecognizer) {
        txtfldData = []
        if txtFldSearch.text == "" {
            self.isSearching = false
        } else {
            self.isSearching = true
//            filterString = textField.text!
            for item in ItemsEntity.shared.getFavData() {
                if item.title.lowercased().contains((txtFldSearch.text!.lowercased())){
                    txtfldData.append(item)
                }
            }
        }
        self.clcViewFavorite.reloadData()
    }
    
}


extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching == false {
            return faveriteData.count
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
    
    func loadCollectionView(_ data: [ItemsModel],_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FavoriteCVC = clcViewFavorite.dequeueReusableCell(withReuseIdentifier: "FavoriteCVC", for: indexPath) as! FavoriteCVC
        cell.fillData(data[indexPath.row])
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.lblTitle.text = data[indexPath.row].title
        if faveriteData[indexPath.row].fav == "true" {
            cell.imgFavorite.image = UIImage(named: "Vector Red")
        } else {
            cell.imgFavorite.image = UIImage(named: "Vector")
        }
        cell.lblNote.text = data[indexPath.row].locaziation()
        cell.imgLanguegaB.getImage()
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching == false {
            return loadCollectionView(faveriteData, indexPath)
        } else {
            return loadCollectionView(txtfldData, indexPath)
        }
    }
    
    func getScreen(_ data: [ItemsModel],_ indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showFav:ShowFavVC = storyboard.instantiateViewController(withIdentifier: "ShowFavVC") as! ShowFavVC
        showFav.checkData = indexPath.row
        showFav.showDataFav = faveriteData
        showFav.onComplete = { [weak self] in
            self?.faveriteData = ItemsEntity.shared.getFavData()
            self?.clcViewFavorite.reloadData()
        }
        self.present(showFav, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearching == false {
            getScreen(faveriteData, indexPath)
        } else {
            getScreen(txtfldData, indexPath)
        }
    }
    
}

extension FavoriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 344 * scale, height: 173 * scale)
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
