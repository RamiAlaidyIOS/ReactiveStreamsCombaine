import UIKit
import Foundation

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let data = try encoder.encode(employee)
let string = String(data: data, encoding: .utf8)!
let sameEmployee = try decoder.decode(Employee.self, from: data)

encoder.keyEncodingStrategy = .convertToSnakeCase
decoder.keyDecodingStrategy = .convertFromSnakeCase

encoder.dateEncodingStrategy = .formatted(.dateFormatter)
decoder.dateDecodingStrategy = .formatted(.dateFormatter)

print(string)

print(data.indices)

print(sameEmployee)

print(encoder.dateEncodingStrategy)
print(decoder.userInfo)

// 1
extension DateFormatter {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
  }()
}
// 2

///////  Example
///
import UIKit

protocol Serializable: Codable {
    func serialize () -> Data?
}
extension Serializable {
    func serialize () -> Data? {
        let encoder = JSONEncoder ( )
        return try? encoder.encode(self)
    }
}

struct Language : Codable {
    var name :String
    var version :Int
    func toDictionary () -> [String:Any] {
        return ["name": self.name,
                "version": self.version]
    }
}
let language = Language(name: "swift", version: 4)
//let data = language.serialize()
let encoderEx = JSONEncoder()
let encodedEx = try? encoder.encode(language)
let decoderEx = JSONDecoder()
let obj = try? decoder.decode (Language.self, from: encodedEx!)

//

