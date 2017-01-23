//
//  ViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class HomeViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var createPlanButton: UIButton!
  
  let collectionViewCellIdentifier = "HomeCollectionViewCell"
  let refreshControl = UIRefreshControl()
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("----- viewDidLoad -----")
    SVProgressHUD.dismiss()
    refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
    self.title = "Home"
    setupCollectionView()
    fetchAPI()
    setupCreatePlanButton()
  }
  
  @IBAction func tappedCreatePlanButton(_ sender: Any) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePlanVC") as? CreatePlanViewController {
      self.present(vc, animated: true, completion: nil)
    }
  }
  
  @IBAction func tappedRightBarButton(_ sender: Any) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RoomVC") as? RoomViewController {
        self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func reload(_ sender: Any?) {
    DispatchQueue.main.async {
      self.collectionView?.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
  
  func fetchAPI() {
    MercuryAPI.sharedInstance.fetchPlanInfoList(completionHandler: {
      self.collectionView?.reloadData()
      self.refreshControl.endRefreshing()
    })
  }
  
  // : UI
  func setupCollectionView() {
    let nib = UINib(nibName: collectionViewCellIdentifier, bundle: nil)
    self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    self.collectionView?.delegate = self
    self.collectionView?.dataSource = self
    self.collectionView?.refreshControl = refreshControl
    reload(nil)
  }
  
  func setupCreatePlanButton() {
    self.createPlanButton?.backgroundColor = Settings.Color.mercuryColor
    let rect = CGRect(x: self.view.frame.size.width-80, y: self.view.frame.size.height-80, width: 100.0, height: 100.0)
    self.createPlanButton?.frame = rect
    self.createPlanButton?.layer.cornerRadius = createPlanButton.frame.size.width/2
    self.createPlanButton?.clipsToBounds = true
    self.createPlanButton?.tintColor = UIColor.white
    self.createPlanButton?.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

/// UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return Settings.Size.collectionCellSize
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Tapped cell!")
    /// 詳細画面へ遷移
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPlanVC") as? DetailPlanViewController {
      vc.giveStr = MercuryAPI.sharedInstance.plans[indexPath.row].give
      vc.takeStr = MercuryAPI.sharedInstance.plans[indexPath.row].take
      vc.planImageURL = MercuryAPI.sharedInstance.plans[indexPath.row].image_url
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MercuryAPI.sharedInstance.plans.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
    cell.giveLabel.text = MercuryAPI.sharedInstance.plans[indexPath.row].give
    cell.takeLabel.text = MercuryAPI.sharedInstance.plans[indexPath.row].take
    cell.giveLabel.textColor = UIColor.black
    cell.takeLabel.textColor = UIColor.black
    if let image_url_string = MercuryAPI.sharedInstance.plans[indexPath.row].image_url {
      let image_url: NSURL = NSURL(string: image_url_string)!
      cell.planImageView?.sd_setImage(with: image_url as URL, placeholderImage: placeholderView, options: .lowPriority
      , completed: {
        image, error, cacheType, imageUrl in
        if error != nil {
          return
        }
        if image != nil && cacheType == .none {
          cell.planImageView?.fadeIn(duration: FadeType.Slow.rawValue)
        }
      })
      
      cell.planImageView?.contentMode = .scaleAspectFill
      cell.planImageView?.layer.masksToBounds = true
    }
    cell.backgroundColor = UIColor.lightGray
    return cell
  }
  
}
