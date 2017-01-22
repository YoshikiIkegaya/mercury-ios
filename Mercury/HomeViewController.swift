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
  
  let placeholderView = UIIma
  //imageWithColor(UIColor.whiteColor())
  let collectionViewCellIdentifier = "HomeCollectionViewCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupCollectionView()
    fetchAPI()
    
    
    
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
    cell?.backgroundColor = UIColor.lightGray
    cell?.imageView?.sd_setImage(with: NSURL(string: MercuryAPI.sharedInstance.plans[indexPath.row].image_url), placeholderImage: <#T##UIImage!#>, options: .lowPriority)
    
    return cell!
  }

}
