//
//  ItemsVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/2/20.
//

import UIKit
import SQLite
import GoogleMobileAds
import FBAudienceNetwork

class ItemsVC: UIViewController, LoadDelegate {

    @IBOutlet weak var heightS: NSLayoutConstraint!
    @IBOutlet weak var trailingBtn2: NSLayoutConstraint!
    @IBOutlet weak var topCLV: NSLayoutConstraint!
    @IBOutlet weak var leadviewSC: NSLayoutConstraint!
    @IBOutlet weak var topBtn1C: NSLayoutConstraint!
    @IBOutlet weak var leadBtn1C: NSLayoutConstraint!
    @IBOutlet weak var leadSearchC: NSLayoutConstraint!
    @IBOutlet weak var leadImgC: NSLayoutConstraint!
    @IBOutlet weak var clcViewItems: UICollectionView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnnSearch: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    var checkId: Int = 0
    var itemsData: [ItemsModel] = []
    var txtfldData: [ItemsModel] = []
    var isSearching: Bool = false
    var name: String = ""
    var scale = DEVICE_WIDTH / 414

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewSearch)
        clcViewItems.register(UINib(nibName: "ItemsCVC", bundle: nil), forCellWithReuseIdentifier: "ItemsCVC")
        clcViewItems.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nativeAdmobCLVCell.className)
        viewSearch.isHidden = true
        btnnSearch.isHidden = false
        lblName.isHidden = false
        clcViewItems.layer.cornerRadius = 10 * scale
        viewSearch.layer.cornerRadius = 30 * scale
        clcViewItems.dataSource = self
        clcViewItems.delegate = self
        scaleToFill()
        itemsData = ItemsEntity.shared.getDataCatId(checkId)
        lblName.text = name
        txtFldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        AdmobManager.shared.loadBannerView(inVC: self)
        AdmobManager.shared.loadAllNativeAds()
        self.hideKeyboardWhenTappedAround()
    }
    
    func updateAnswerFav() {
        itemsData = ItemsEntity.shared.getDataCatId(checkId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsData = ItemsEntity.shared.getDataCatId(checkId)
        if PaymentManager.shared.isPurchase() {
            if fbNativeAds != nil{
                fbNativeAds = nil
                clcViewItems.reloadData()
            }
            if admobNativeAds != nil{
                admobNativeAds = nil
                clcViewItems.reloadData()
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
                clcViewItems.reloadData()
            }
        }
        self.clcViewItems.reloadData()
    }
    
    func scaleToFill() {
        leadImgC.constant = 20 * scale
        leadSearchC.constant = 10 * scale
        leadBtn1C.constant = 32 * scale
        topBtn1C.constant = 61 * scale
        leadviewSC.constant = 19 * scale
        topCLV.constant = 16 * scale
        trailingBtn2.constant = 31 * scale
        lblName.font = lblName.font.withSize(20 * scale)
        heightS.constant = 56 * scale
        txtFldSearch.font = txtFldSearch.font?.withSize(16 * scale)
    }

    @IBAction func btn_Back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Search(_ sender: Any) {
        viewSearch.isHidden = false
        btnnSearch.isHidden = true
    }
    
    @objc func textFieldDidChange (_ sender: UITapGestureRecognizer) {
        txtfldData = []
        if txtFldSearch.text == "" {
            self.isSearching = false
        } else {
            self.isSearching = true
//            filterString = textField.text!
            for item in ItemsEntity.shared.getDataCatId(checkId) {
                if item.title.lowercased().contains((txtFldSearch.text!.lowercased())){
                    txtfldData.append(item)
                }
            }
        }
        self.clcViewItems.reloadData()
    }

}

extension ItemsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching == false {
            return itemsData.count
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
        let cell:ItemsCVC = clcViewItems.dequeueReusableCell(withReuseIdentifier: "ItemsCVC", for: indexPath) as! ItemsCVC
        cell.fillData(data[indexPath.row])
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.lblTitle.text = data[indexPath.row].title
        if data[indexPath.row].fav == "false" {
            cell.imgFavorite.image = UIImage(named: "Vector")
        } else {
            cell.imgFavorite.image = UIImage(named: "Vector Red")
        }
        cell.lblNote.text = data[indexPath.row].locaziation()
        cell.imgLogoB.getImage()
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching == false {
            return loadCollectionView(itemsData, indexPath)
        } else {
            return loadCollectionView(txtfldData, indexPath)
        }
    }
    
    func getScreen(_ data: [ItemsModel],_ indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let show:ShowVC = storyboard.instantiateViewController(withIdentifier: "ShowVC") as! ShowVC
        show.checkData = data[indexPath.row].id - itemsData[0].id
        show.name = data[indexPath.row].cat_name
        show.checkId = checkId
        self.present(show, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearching == false {
            getScreen(itemsData, indexPath)
        } else {
            getScreen(txtfldData, indexPath)
        }
    }
    
}

extension ItemsVC: UICollectionViewDelegateFlowLayout {
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


