//
//  ViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let collectionViewCellIdentifier = "HomeCollectionViewCell"
  let refreshControl = UIRefreshControl()
  let placeholderView = UIImage.imageWithColor(color: UIColor.white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("----- viewDidLoad -----")
    refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
    self.title = "Home"
    setupCollectionView()
    fetchAPI()
  }
  
  func reload(_ sender: Any?) {
    DispatchQueue.main.async {
      self.collectionView?.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
  
  func fetchAPI() {
    MercuryAPI.sharedInstance.fetchPlanInfoList()
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
    
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MercuryAPI.sharedInstance.plans.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell
    cell?.giveLabel.text = MercuryAPI.sharedInstance.plans[indexPath.row].give
    cell?.giveLabel.textColor = UIColor.black
    cell?.takeLabel.text = MercuryAPI.sharedInstance.plans[indexPath.row].take
    cell?.takeLabel.textColor = UIColor.black
    
    let image_url_string = MercuryAPI.sharedInstance.plans[indexPath.row].image_url
    var image_url: NSURL = NSURL(string: image_url_string!)!
    cell?.imageView.sd_setImage(with: image_url as URL!, placeholderImage: placeholderView, options: .lowPriority)
    
    cell?.backgroundColor = UIColor.lightGray
    return cell!
  }
  
}
