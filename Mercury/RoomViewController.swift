//
//  RoomViewController.swift
//  Mercury
//
//  Created by toco on 23/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableViewUI()
  }

  func setupTableViewUI() {
    let nib = UINib(nibName: "RoomTableViewCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: "Cell")
    self.tableView?.delegate = self
    self.tableView?.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension RoomViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Settings.Size.roomTableViewCellSize
  }
}

extension RoomViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomTableViewCell

    return cell
  }
}
