
import Foundation


public extension Measurement {
  
  func description(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    let usableSignificantDigits = significantDigits > 0 ? significantDigits : 0
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = usableSignificantDigits
    formatter.minimumFractionDigits = usableSignificantDigits
    
    let value = abs(self.value)
    let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value))"
    
    return includeUnit ? "\(valueString) \(self.unit.symbol)" : valueString
  }
}
