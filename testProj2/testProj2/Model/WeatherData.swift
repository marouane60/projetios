
import Foundation
import UIKit

struct WeatherData: Decodable {
    var main: String
    var desc : String
    var icon : String
    var temperature : Float
    var pressure: Float
    var humidity: Float
    var wind : Float
    var clouds : Float
    var city : String
    var country : String
}
