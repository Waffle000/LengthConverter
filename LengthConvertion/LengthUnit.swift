//
//  LengthUnit.swift
//  LengthConvertion
//
//  Created by Enrico Maricar on 25/06/24.
//

enum LengthUnit: String, CaseIterable, Identifiable {
    case km = "Km"
    case hm = "Hm"
    case dam = "Dam"
    case m = "M"
    case dm = "Dm"
    case cm = "Cm"
    case mm = "Mm"
    
    var id: String { self.rawValue }
    
    var conversionFactorToMeter: Double {
        switch self {
        case .km:
            return 1000.0
        case .hm:
            return 100.0
        case .dam:
            return 10.0
        case .m:
            return 1.0
        case .dm:
            return 0.1
        case .cm:
            return 0.01
        case .mm:
            return 0.001
        }
    }
}
