//
//  SymptomProtocol.swift
//  HistoryWriter
//
//  Created by Sam Sawaya on 3/13/24.
//

import SwiftUI

protocol SymptomProtocol: Identifiable {
    var symptom : String {get}
    var id : UUID {get}
    var hasLocation : Bool {get}
    var locationChoices : [String] {get}
    var characterChoices : [String] {get}
    var aggravatorChoices : [String] {get}
    var relieverChoices : [String]  {get}
    var radiationChoices : [String]  {get}
    var severityChoices : [String]  {get}
    var associatedSymptomChoices : [String]  {get}
    
}

struct Symptoms {
    static let symptomList : [any SymptomProtocol] = [ChestPain(), Syncope()]
}
        

@Observable
class Symptom: Identifiable, Codable {
    var symptom : String
    var id : UUID
    var hasLocation : Bool
    var locationChoices : [String]
    var characterChoices : [String]
    var aggravatorChoices : [String]
    var relieverChoices : [String]
    var radiationChoices : [String]
    var severityChoices : [String]
    var associatedSymptomChoices : [String]
    
    init(symptom: String = "", id: UUID = UUID(), hasLocation: Bool = false, locationChoices: [String] = [String](), characterChoices: [String] = [String](), aggravatorChoices: [String] = [String](), relieverChoices: [String] = [String](), radiationChoices: [String] = [String](), severityChoices: [String] = [String]() , associatedSymptomChoices: [String] = [String]()) {
        self.symptom = symptom
        self.id = id
        self.hasLocation = hasLocation
        self.locationChoices = locationChoices
        self.characterChoices = characterChoices
        self.aggravatorChoices = aggravatorChoices
        self.relieverChoices = relieverChoices
        self.radiationChoices = radiationChoices
        self.severityChoices = severityChoices
        self.associatedSymptomChoices = associatedSymptomChoices
    }
    
    enum CodingKeys: String, CodingKey {
        case _symptom = "symptom"
        case _id = "id"
        case _hasLocation = "hasLocation"
        case _locationChoices = "locationChoices"
        case _characterChoices = "characterChoices"
        case _aggravatorChoices = "aggravatorChoices"
        case _relieverChoices = "relieverChoices"
        case _radiationChoices = "radiationChoices"
        case _severityChoices = "severityChoices"
        case _associatedSymptomChoices = "associatedSymptomChoices"
    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: ._id)
//        hasLocation = try container.decode(Bool.self, forKey: ._hasLocation)
//        locationChoices = try container.decode([String].self, forKey: ._locationChoices)
//        characterChoices = try container.decode([String].self, forKey: ._characterChoices)
//        aggravatorChoices = try container.decode([String].self, forKey: ._aggravatorChoices)
//        relieverChoices = try container.decode([String].self, forKey: ._relieverChoices)
//        radiationChoices = try container.decode([String].self, forKey: ._radiationChoices)
//        severityChoices = try container.decode([String].self, forKey: ._severityChoices)
//        associatedSymptomChoices = try container.decode([String].self, forKey: ._associatedSymptomChoices)
//        symptom = try container.decode(String.self, forKey: ._symptom)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(symptom, forKey: ._symptom)
//        try container.encode(id, forKey: ._id)
//        try container.encode(hasLocation, forKey: ._hasLocation)
//        try container.encode(locationChoices, forKey: ._locationChoices)
//        try container.encode(characterChoices, forKey: ._characterChoices)
//        try container.encode(aggravatorChoices, forKey: ._aggravatorChoices)
//        try container.encode(relieverChoices, forKey: ._relieverChoices)
//        try container.encode(radiationChoices, forKey: ._severityChoices)
//        try container.encode(associatedSymptomChoices, forKey: ._associatedSymptomChoices)
//        try container.encode(severityChoices, forKey: ._severityChoices)
//        
//    }
    
    
}

@Observable
class SymptomChoices : Codable {
    
    var symptoms = [Symptom]()
    
    init() {}
    
    
    enum CodingKeys: String, CodingKey {
        case _symptoms = "symptoms"
    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        symptoms = try container.decode([Symptom].self, forKey: ._symptoms)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(symptoms, forKey: ._symptoms)
//        
//    }
    
    func saveSymptoms() {
        
        if let data = try? JSONEncoder().encode(symptoms) {
            print("**** json data obtained \(data)")
            let symptomFileURL = URL.documentsDirectory.appending(path: "symptoms.json")
            print("**** url \(symptomFileURL.absoluteString)")
            try? data.write(to: symptomFileURL)
        }
        
    }
    
    func loadSymptoms() {
        let symptomFileURL = URL.documentsDirectory.appending(path: "symptoms.json")
        print("**** url \(symptomFileURL.absoluteString)")
        if let data = try? Data(contentsOf: symptomFileURL) {
            print("**** json data obtained \(data)")
            symptoms = (try? JSONDecoder().decode([Symptom].self, from: data)) ?? [Symptom]()
            print("**** symptoms count \(symptoms.count)")
        }
    }
    
    
    
    
}




struct ChestPain : SymptomProtocol {
   
    var locationChoices =  ["left", "right", "let front", "right front", "left back", "right back", "front", "back"]
    
    var symptom = "chest pain"
    
    var id = UUID()
    
    var hasLocation: Bool = true
    
    var characterChoices: [String]  {
        ["pressure",
        "tight",
        "burning",
         "sharp"
         ]
    }
    
    var aggravatorChoices: [String] {
        ["activity", "breathing", "eating", "moving arm", "touching chest", "laying flat", "sitting up", "cocaine", "methamphetamine", "decongestant"]
    }
    
    var relieverChoices: [String] {
        ["nitroglycerine", "rest","activity", "bronchodilator", "analgesic cream", "opiates", "tylenol", "nsaids", "muscle relaxer"]
    }
    
    var radiationChoices: [String] {
        ["left arm", "back", "jaw", "right arm", "abdomen", "head"]
    }
    
    var severityChoices: [String] {
        ["1/10","2/10","3/10","4/10","5/10","6/10","7/10","8/10", "9/10", "10/10", "more than 10/10"]
    }
    
    var associatedSymptomChoices: [String] {
        ["dyspnea", "nausea" , "diaphoresis", "dizziness", "edema", "palpitations", "a recent long trip", "heavy exercise"]
    }
    
}

struct Syncope : SymptomProtocol {
    var locationChoices: [String] = []
    
    var id: UUID = UUID ()
    
    var symptom = "syncope"
    
    var hasLocation: Bool = false
    
    var characterChoices: [String]  {
        ["sudden", "gradual", "preceeded by light headedness", "preceeded by nausea"
         ]
    }
    
    var aggravatorChoices: [String] {
        ["activity", "standing", "using the bathroom", "crowds", "hot room", "stress", "trauma", "pain", "dehydration"]
    }
    
    var relieverChoices: [String] {
        ["sitting", "lying down", "relaxing"]
    }
    
    var radiationChoices: [String] {
        []
    }
    
    var severityChoices: [String] {
        ["causing injury", "causing no injury", "causing an accident"]
    }
    
    var associatedSymptomChoices: [String] {
        ["seizure", "confusion" , "body soreness", "dizziness", "tongue biting", "incontinence", "a recent long trip" , "leg edema", "recent surgery", "palpitations", "chest pain", "nausea"]
    }
    
}
