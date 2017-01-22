//
//  ViewController.swift
//  Mercury
//
//  Created by toco on 22/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  var plans = ["hoge", "foo", "poo"]
  let collectionViewCellIdentifier = "HomeCollectionViewCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupCollectionView()
  }
  
  func setupCollectionView() {
    let nib = UINib(nibName: collectionViewCellIdentifier, bundle: nil)
    self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    self.collectionView?.delegate = self
    self.collectionView?.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    return plans.count
  }
  

  
  
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell
    cell?.label.text = plans[indexPath.row]
    cell?.label.textColor = UIColor.black
    cell?.backgroundColor = UIColor.gray
    return cell!
  }

}
