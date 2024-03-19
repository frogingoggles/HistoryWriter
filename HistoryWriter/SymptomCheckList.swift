//
//  SymptomCheckList.swift
//  HistoryWriter
//
//  Created by Sam Sawaya on 3/13/24.
//

import SwiftUI

@Observable
class SymptomDescriptors {
    
    var symptom : String = ""
    var id = UUID()
    var onset : Int = 0
    var onsetUnit : String = ""
    var hasLocation  = false
    var location : String?
    var duration : Int = 0
    var durationUnit : String = ""
    var character : String?
    var aggravators : [String]?
    var relievers: [String]?
    var timing : String?
    var radiating : [String]?
    var severity : String?
    var associatedSymptoms : [String]?
    var pertinentNegatives : [String]?
    var otherInfo: String?
    
    init(symptom: String = "", onset: Int = 0, onsetUnit: String = "", hasLocation: Bool = false, location: String? = nil, duration: Int = 0, durationUnit: String = "", character: String? = nil, aggravators: [String]? = nil, relievers: [String]? = nil, timing: String? = nil, radiating: [String]? = nil, severity: String? = nil, associatedSymptoms: [String]? = nil, pertinentNegatives: [String]? = nil, otherInfo: String? = nil) {
        self.symptom = symptom
        self.onset = onset
        self.onsetUnit = onsetUnit
        self.hasLocation = hasLocation
        self.location = location
        self.duration = duration
        self.durationUnit = durationUnit
        self.character = character
        self.aggravators = aggravators
        self.relievers = relievers
        self.timing = timing
        self.radiating = radiating
        self.severity = severity
        self.associatedSymptoms = associatedSymptoms
        self.pertinentNegatives = pertinentNegatives
        self.otherInfo = otherInfo
    }
    
    init() {}
    
    var historyString : String {
        var portions = [String]()
        portions += ["The patient reports \(symptom)."]
        if hasLocation, let location {
            portions += ["It was located in the \(location)."]
        }
        if let radiating, !radiating.isEmpty {
            portions += ["It radiated to \(radiating.formatted())."]
        }
        if !onsetUnit.isEmpty && onset > 0 {
            portions += ["^[It started \(onset) \("\(onsetUnit)") ago.](inflect: true)"]
        }
        if let character {
            portions += ["The \(symptom) was \(character)."]
        }
        if !durationUnit.isEmpty && duration > 0 {
            portions += ["^[It has lasted \(duration) \("\(durationUnit)").](inflect: true)"]
        }
        
        if let timing ,!timing.isEmpty {
            portions += ["It has occurred \(timing)."]
        }
        
        if let severity {
            portions += ["It had a severity of \(severity)."]
        }
        
        
        if let aggravators {
            portions += ["It was made worse by \(aggravators.formatted())."]
        }
        if let relievers {
            portions += ["It was made better by \(relievers.formatted())."]
        }
        if let associatedSymptoms {
            portions += ["It has been associated with \(associatedSymptoms.formatted())."]
        }
        if let pertinentNegatives {
            portions += ["The patient has not had \(pertinentNegatives.formatted())."]
        }
        
        var string = portions.joined(separator: " ")
        if let otherInfo {
            string = string + "\n\n" + otherInfo
        }
        
        return string
    }
    
}








