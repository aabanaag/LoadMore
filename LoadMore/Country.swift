//
//  Country.swift
//  LoadMore
//
//  Created by Jong Banaag on 20/11/2017.
//  Copyright © 2017 Jong Banaag. All rights reserved.
//

import UIKit

class Country: NSObject {
  let name: String
  
  init(countryInformation: [String: Any]) {

    name = countryInformation["name"] as! String
  }
}
