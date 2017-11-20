//
//  CountriesTableViewController.swift
//  LoadMore
//
//  Created by Jong Banaag on 19/11/2017.
//  Copyright © 2017 Jong Banaag. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO

class CountriesTableViewController: UITableViewController {
  let feathers: Feathers = Feathers(provider: SocketProvider(baseURL: URL(string: "http://localhost:3030")!, configuration: []))
  var countryService: ServiceType!
  var countries: [Country]! = []
  var skip: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countryService = feathers.service(path: "countries")
    countryService.on(event: .created)
      .observeValues { entity in
        print(entity)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    loadCountries()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    countryService.off(event: .created)
  }
  
  func loadCountries() {
    let query = Query()
      .limit(20)
      .skip(skip)
    
    print(query.serialize())
    countryService.request(.find(query: query))
      .on(value: { response in
        let data = response.data.value as! [[String: Any]]
        
        data.forEach({ (info) in
          let existing = self.countries.first(where: { (country) -> Bool in
            return country.name == info["name"] as! String
          })
          
          if existing == nil {
            self.countries.append(Country(countryInformation: info))
          }
        })

        self.skip += 20
        self.tableView.reloadData()
      })
      .start()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return countries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "country")
    
    if indexPath.row == skip - 3 {
      loadCountries()
    }
    
    if countries[indexPath.row] != nil {
      let country = countries[indexPath.row]
  
      cell?.textLabel?.text = country.name
    }
    
    return cell!
  }
}
