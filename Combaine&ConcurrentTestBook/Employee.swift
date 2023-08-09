//
//  Employee.swift
//  Combaine&ConcurrentTestBook
//
//  Created by Rami Alaidy on 07/08/2023.
//

import Foundation
import UIKit

 struct Employee: Codable {

  var name: String
  var id: Int
  var favoriteToy: Toy

     
//     func encode(to encoder: Encoder) throws {
//       // 2
//       var container = encoder.container(keyedBy: CodingKeys.self)
//       // 3
//       try container.encode(name, forKey: .name)
//       try container.encode(id, forKey: .id)
//       // 4
//         try container.encode(favoriteToy.name, forKey: .favoriteToy)
//     }

}


