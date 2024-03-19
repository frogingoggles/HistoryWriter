//
//  AddNewSymptomView.swift
//  HistoryWriter
//
//  Created by Sam Sawaya on 3/15/24.
//

import SwiftUI

struct AddNewSymptomView: View {
    
    @Binding var symptomOptions : [String]
    var optionType: String
    @State private var optionToAdd = ""
    
    var body: some View {
        Form {
            
            
            
            Section(optionType) {
                
                    HStack {
                        TextField("Add \(optionType)", text: $optionToAdd, prompt: Text("Add \(optionType)"))
                        Button("Add \(optionType)", systemImage: "plus") {
                            symptomOptions += [optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines)]
                            optionToAdd = ""
                        }.labelStyle(.iconOnly)
                            .disabled(optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    ForEach(symptomOptions, id:\.self) { option in
                        Text(option)
                    }.onDelete  { indexSet in
                        for index in indexSet {
                            symptomOptions = symptomOptions.filter({$0 != symptomOptions[index]})
                        }
                        
                        
                    }
                
                
            }
        }.navigationTitle(optionType)
    }
    
    func save() {
        
    }
    
}

#Preview {
    AddNewSymptomView(symptomOptions: Binding.constant(["location"]), optionType: "location")
}
