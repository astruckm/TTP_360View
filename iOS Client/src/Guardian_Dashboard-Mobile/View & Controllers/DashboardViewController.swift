//
//  ViewController.swift
//  Guardian_Dashboard-Mobile
//
//  Created by Andrew Struck-Marcell on 11/1/19.
//  Copyright © 2019 Andrew Struck-Marcell. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var dashboardItemsCollectionView: UICollectionView!
    @IBOutlet weak var btUsersContainerView: UIView!
    
    let socketManager = SocketIOManager.shared
    var items: [DashboardItem] = DashboardItem.defaultItems {
        didSet {
            socketManager.sendJSON(with: UIDevice.current.identifierForVendor?.uuidString ?? "",
                                   connectionStatus: "disconnected",
                                   newBTLEUsers: [BTLE(deviceName: "John's iphone", sigStrength: "proximate", btSystem: "BLE"), BTLE(deviceName: "ABCDE", sigStrength: "weak", btSystem: "BLE")])
        }
    }
    var collectionViewWidth: CGFloat { return dashboardItemsCollectionView.bounds.width }
    var collectionViewHeight: CGFloat { return dashboardItemsCollectionView.bounds.height }
    var itemHeight: CGFloat { return collectionViewHeight / 5 }
    
    @IBAction func hiddenChangeButtonTapped(_ sender: UIButton) {
        print("hiddenChangeButtonTapped")
        changeInStatus()
        //        presentBTUsersVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func changeInStatus() {
        items[0] = DashboardItem(type: .lte(signalStrength: .noSignal))
        socketManager.updateInterval = 300
        dashboardItemsCollectionView.reloadData()
    }
    
    func presentBTUsersVC() {
        let btUsersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardStrings.btUsersVCID) as! BTUsersViewController
        btUsersVC.modalPresentationStyle = .popover
        btUsersVC.newBTLEUsers = ["John's iphone", "ABCDE"]
        present(btUsersVC, animated: true, completion: nil)
    }
    
    func presentNFCTransmissionsVC() {
        let nfcTransmissionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardStrings.nfcTransmissionsVCID) as! NFCTransmissionsViewController
        nfcTransmissionsVC.modalPresentationStyle = .popover
        present(nfcTransmissionsVC, animated: true, completion: nil)
    }
    
    func presentVPNConnectionsVC() {
        let vpnConnectionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardStrings.vpnConnectionsVCID) as! VPNConnectionsViewController
        vpnConnectionsVC.modalPresentationStyle = .popover
        present(vpnConnectionsVC, animated: true, completion: nil)
    }
    
    func presentWifiConnectionsVC() {
        let wifiConnectionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardStrings.wifiConnectionsVCID) as! WiFiConnectionsViewController
        wifiConnectionsVC.modalPresentationStyle = .popover
        present(wifiConnectionsVC, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popOverSize = CGSize(width: view.bounds.width/2, height: view.bounds.height/2)
        if let vc = segue.destination as? BTUsersViewController {
            let controller = vc.popoverPresentationController
            controller?.delegate = self
            //            controller?.permittedArrowDirections = .down
            controller?.sourceView = dashboardItemsCollectionView.visibleCells[1].contentView
            controller?.sourceRect = dashboardItemsCollectionView.visibleCells[1].contentView.frame
            vc.preferredContentSize = popOverSize
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    
    
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardStrings.dashboardItemRestoreID, for: indexPath) as? DashboardItemCollectionViewCell else { return UICollectionViewCell() }
        let item = items[indexPath.item]
        cell.itemName.text = item.name
        cell.itemImageView.image = item.image
        cell.notActiveImageView?.image = item.notActiveImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            presentBTUsersVC()
        } else if indexPath.item == 2 {
            presentNFCTransmissionsVC()
        } else if indexPath.item == 4 {
            presentVPNConnectionsVC()
        } else if indexPath.item == 5 {
            presentWifiConnectionsVC()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWidth/4, height: itemHeight)
    }
    
}

extension DashboardViewController: UIPopoverPresentationControllerDelegate {
    
}

