//
//  SearchStationViewController.swift
//  Reseersättaren
//
//  Created by Andreas Åström on 9/17/18.
//  Copyright © 2018 Jonatan Tegen. All rights reserved.
//

import UIKit
import Foundation


class SearchStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    
    @IBOutlet weak var SearchFromStationTable: UITableView!
    @IBOutlet weak var SearchStationListInput: UISearchBar!
    
    var mainList = [String]()
    var stationList:[String] = []
    var filtered:[String] = []
    var searchActive : Bool = false
    var selectedStation = "hej"
    
    func LoadStationList() {
        mainList = ["Lund C", "Malmö C", "Malmö Hyllie", "Triangeln",
         "CPH Airport",
         "Lund Botulfsplatsen",
         "Lund Univ-sjukhuset",
         "Lund Bankgatan",
         "Lund Bantorget",
         "Ludvigsborgs friskola",
         "Lundavägen 1 Malmö",
         "Lundsbäcksgatan 5 Helsingborg",
         "Luftkastellet",
         "Lugna Gården",
         "Lugna gatan 1 Malmö",
         "Luhrsjöbaden",
         "Lundegatan 1 Simrishamn",
         "Lupinvägen 1 Löddeköpinge"]
        
        stationList = mainList
        
    }
    
    // numberOfRowsInsections = hur många rader ska vi ha i listan
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationList.count
    }
    
    //CellForRowAt = här bygger man hur cellen ska se ut och vad man ska ha i varje cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SearchStationRow", for: indexPath)
        cell.textLabel?.text = stationList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStation = stationList[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name.fromStation, object: self)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        stationList = mainList.filter { $0.lowercased().contains(searchText.lowercased()) }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.SearchFromStationTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadStationList()
        SearchFromStationTable.delegate = self
        SearchFromStationTable.dataSource = self
        SearchStationListInput.delegate = self
    }
}
