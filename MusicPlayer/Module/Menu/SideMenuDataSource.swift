//
//  SideMenuDataSource.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation

import UIKit

class SideMenuDataSource: NSObject {
  
  private(set) var rows: [Row] = []
  
}

// MARK: - UITableViewDataSource

extension SideMenuDataSource: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = rows[indexPath.row].type.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    configureTableViewCell(cell, at: indexPath)
    return cell
  }
  
}

// MARK: - Configure Cell

private extension SideMenuDataSource {
  
  func configureTableViewCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
    let row = rows[indexPath.row]
    cell.textLabel?.text = row.title
  }
  
}

// MARK: - Reload Sections

extension SideMenuDataSource {
  
  func reloadSections() {
    
    let home = Row(type: .home, title: "Home".localized())
    
    let favorite = Row(type: .favorite, title: "Favorite".localized())
    
    let changeLanguage = Row(type: .changeLanguage, title: "changeLanguage".localized())
    
   
    
    self.rows = [home, favorite, changeLanguage]
  }
  
}

// MARK: - Constants

extension SideMenuDataSource {
  
  enum RowType {
    case home
    case favorite
    case changeLanguage
    
    
    /// In case of multiple cells ya Emad
    var reuseIdentifier: String {
      "\(UITableViewCell.self)"
    }
  }
  
  struct Row {
    let type: RowType
    let title: String?
  }
  
}
