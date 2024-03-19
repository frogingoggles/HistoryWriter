//
//  ContentView.swift
//  HistoryWriter
//
//  Created by Sam Sawaya on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    
    //    @State private var selectedSymptom : (any SymptomProtocol)?
    @State private var selectedSymptom : Symptom?
    @State private var selectedSymptomDescriptors = SymptomDescriptors()
    @State private var searchText = ""
    @State private var showSearch = true
//    @State private var selectedCharacter = ""
//    @State private var selectedLocation = ""
    private var timeUnits = ["","second","minutes", "hour", "day", "month", "year"]
//    @State private var selectedOnsetUnits = ""
//    @State private var selectedOnset = 0
//    @State private var selectedDuration = 0
//    @State private var selectedDurationUnits = ""
//    @State private var selectedTiming = ""
//    @State private var selectedAggrevators = [String]()
//    @State private var selectedRelievers = [String()]
//    @State private var selectedSeverity = ""
//    @State private var associatedConditions = [String]()
//    @State private var pertinentNegatives = [String]()
//    @State private var other = ""
    @State private var evaluatedSymptoms = [SymptomDescriptors]()
    @State private var symptomChoices = SymptomChoices()
    
    @State private var showAddSymptomSheet = false
    @State private var showOtherLocation = false
    @State private var addSymptom = false
    @State private var newSymptomName = ""
    @State private var willHaveLocation = false
    @State private var editSymptomOptions : OptionChoices?
    
    enum OptionChoices : String, Identifiable {
        
        var id: Self {
            return self
        }
        case location, character, aggravator, reliever, radiation, severity, associatedSymptoms
    }
    
    
    
    
    var body: some View {
        NavigationStack{
            
            Form {
                if let selectedSymptom {
                    Group{
                    
                    Group {
                        if selectedSymptom.hasLocation {
                            optionPicker(optionType: .location)
                        } else {
                            toggleHasLocation
                        }
                        
                        optionPicker(optionType: .character)
                        
                        optionPicker(optionType: .severity)
                        
                    }
                    
                    
                    Group {
                        Section("Onset") {
                            Picker("Onset Unit", selection: $selectedSymptomDescriptors.onsetUnit) {
                                ForEach(timeUnits, id:\.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            
                            Picker("^[\(selectedSymptomDescriptors.onset) \("\(selectedSymptomDescriptors.onsetUnit)")](inflect: true)", selection: $selectedSymptomDescriptors.onset) {
                                ForEach(0...59, id:\.self) { index in
                                    Text(String(index)).tag(index)
                                }
                            }
                            
                        }
                        
                        Section("Timing") {
                            Picker("Timing", selection: $selectedSymptomDescriptors.timing) {
                                Text("").tag(nil as String?)
                                Text("only once").tag("only once" as String?)
                                Text("intermittently").tag("intermittent" as String?)
                                Text("continuously").tag("continuous" as String?)
                            }
                        }
                        
                        Section("Duration") {
                            Picker("Duration Unit", selection: $selectedSymptomDescriptors.durationUnit) {
                                ForEach(timeUnits, id:\.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            
                            Picker("^[\(selectedSymptomDescriptors.duration) \("\(selectedSymptomDescriptors.durationUnit)")](inflect: true)", selection: $selectedSymptomDescriptors.duration) {
                                ForEach(0...59, id:\.self) { index in
                                    Text(String(index)).tag(index)
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    
                        multiOptionSelector(optionType: .aggravator)
                        multiOptionSelector(optionType: .reliever)
                        
                        associatedConditionLink
                    

                    
                                            
                    
                }
                    .sheet(item: $editSymptomOptions) {
                        symptomChoices.saveSymptoms()
                    } content: { item in
                        addNewOptionsView(optionType: item)
                    }
            }
                
                
            }
            
            
            .onAppear {
                symptomChoices.loadSymptoms()
            }
            .onDisappear {
                symptomChoices.saveSymptoms()
            }
            .toolbar  {
                ToolbarItem {
                    Button("Add New Symptom", systemImage: "plus") {
                        addSymptom = true
                    }
                    .alert("Add New Symptom", isPresented: $addSymptom) {
                        TextField("Add New Symptom", text: $newSymptomName, prompt: Text("Add New Symptoms"))
                        Button("Add") {
                            symptomChoices.symptoms += [Symptom(symptom: newSymptomName)]
                            symptomChoices.saveSymptoms()
                        }
                        Button("Cancel", role: .cancel) {}
                        
                    }
                    
                    
                }
                
            }
            .navigationTitle(selectedSymptom?.symptom ?? "")
            .searchable(text: $searchText, isPresented: $showSearch, placement: .navigationBarDrawer(displayMode: .always), prompt: "What Symptom?")
            .searchSuggestions {
                if !evaluatedSymptoms.isEmpty {
                    ForEach(evaluatedSymptoms, id:\.id) { symptom in
                        Button(symptom.symptom) {
                            selectedSymptomDescriptors = symptom
                        }
                    }
                    Divider()
                }
                
                ForEach(filteredSymptoms, id:\.id) { symptom in
                    if !evaluatedSymptoms.contains(where: { symptomDescriptor in
                        symptomDescriptor.symptom == symptom.symptom
                    }) {
                        Button(symptom.symptom) {
                            resetSelections()
                            selectedSymptom = symptom
                            selectedSymptomDescriptors = SymptomDescriptors(symptom: symptom.symptom)
                            showSearch = false
                        }
                    }
                }
            }
        }
    }
    
    
    func addNewOptionsView(optionType: OptionChoices) -> some View {
        
       let localStringArray = localStringArray(optionType: optionType)
        
        
        return Group {
            if let localStringArray {
                AddNewSymptomView(symptomOptions: localStringArray, optionType: optionType.rawValue)
            } else {
                Text("Could not load View")
            }
        }
        
    }
    
    
    func localStringArray(optionType: OptionChoices) -> Binding<[String]>? {
        var localStringArray : Binding<[String]>?
        
        
        switch optionType {
        case .location :
            localStringArray  = Binding {
                selectedSymptom?.locationChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.locationChoices = newValue
            }
        case .character :
            localStringArray  = Binding {
                selectedSymptom?.characterChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.characterChoices = newValue
            }
        case .aggravator :
            localStringArray  = Binding {
                selectedSymptom?.aggravatorChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.aggravatorChoices = newValue
            }
        case .reliever:
            localStringArray  = Binding {
                selectedSymptom?.relieverChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.relieverChoices = newValue
            }
        case .radiation :
            localStringArray  = Binding {
                selectedSymptom?.radiationChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.radiationChoices = newValue
            }
        case .severity :
            localStringArray  = Binding {
                selectedSymptom?.severityChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.severityChoices = newValue
            }
        case .associatedSymptoms :
            localStringArray  = Binding {
                selectedSymptom?.associatedSymptomChoices ?? [String]()
            } set: { newValue in
                selectedSymptom?.associatedSymptomChoices = newValue
            }

        }
        
        return localStringArray
        
    }
    
    func optionPicker(optionType: OptionChoices) -> some View {
        
        
        let localStringArray = localStringArray(optionType: optionType)
        
        var selector : Binding<String?> {
            switch optionType {
            case .location:
                return $selectedSymptomDescriptors.location
            case .character:
                return $selectedSymptomDescriptors.character
            case .severity:
                return $selectedSymptomDescriptors.severity
            default:
                return Binding.constant("")
            }
        }
        
        return Group {
            if let localStringArray {
                Picker(optionType.rawValue.capitalized, selection: selector) {
                    Text("").tag(nil as String?)
                    ForEach(localStringArray, id:\.self) { option in
                        Text(option.wrappedValue).tag(option.wrappedValue as String?)
                        
                        
                    }
                    
                }.swipeActions {
                    Button("Add") {
                        editSymptomOptions = optionType
                    }
                    
                    
                }
            } else {
                Text("Could not load View")
            }
        }
        
    }
    
    
    
    func multiOptionSelector(optionType : OptionChoices) -> some View {
        
        
        let options = localStringArray(optionType: optionType)
        
        var selectedOptions : Binding<[String]>
        
        switch optionType {
        case .aggravator:
              selectedOptions  = Binding {
                  selectedSymptomDescriptors.aggravators ?? [String]()
            } set: { newValue in
                selectedSymptomDescriptors.aggravators = newValue
            }
        case .reliever:
              selectedOptions  = Binding {
                  selectedSymptomDescriptors.relievers ?? [String]()
            } set: { newValue in
                selectedSymptomDescriptors.relievers = newValue
            }
        default:
            selectedOptions = Binding.constant([""])
        }
        

        
        return Group {
            if let options {
                NavigationLink {
                    Form{
                        Section {
                            ForEach(options, id:\.self) { option in
                                
                                Button {
                                    
                                 
                                    if selectedOptions.wrappedValue.contains(option.wrappedValue) {
                                        selectedOptions.wrappedValue = selectedOptions.wrappedValue.filter({$0 != option.wrappedValue})
                                    } else {
                                        selectedOptions.wrappedValue += [option.wrappedValue]
                                    }
                                    symptomChoices.saveSymptoms()
                                    
                                } label: {
                                    HStack {
                                        Text(option.wrappedValue)
                                        if selectedOptions.wrappedValue.contains(option.wrappedValue) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                
                            } .onDelete { indexSet in
                                for index in indexSet {
                                    selectedOptions.wrappedValue = selectedOptions.wrappedValue.filter({$0 != options.wrappedValue[index]})
                                    options.wrappedValue = options.wrappedValue.filter({$0 != options.wrappedValue[index]})
                                }
                                symptomChoices.saveSymptoms()
                            }
                            
                            
                        } header: {
                            HStack {
                                Text((optionType.rawValue.capitalized))
                                Spacer()
                                
                            }
                        }
                        Section("Add New Option:") {
                            HStack {
                                TextField("Add \(optionType.rawValue)", text: $optionToAdd, prompt: Text("Add \(optionType.rawValue)"))
                                Spacer()
                                Button("Add \(optionType.rawValue)", systemImage: "plus") {
                                    if !optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        options.wrappedValue += [optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines)]
                                        optionToAdd = ""
                                        symptomChoices.saveSymptoms()
                                    }
                                    
                                }.labelStyle(.iconOnly)
                                    .buttonStyle(.borderless)
                            }
                        }
                    }
                    
                } label: {
                    Text("\(optionType.rawValue.capitalized): \(selectedOptions.wrappedValue.formatted())")
                }
            } else {
                Text("Can not load view")
            }
        }
        
    }
    
    @State private var optionToAdd = ""
    
    
    var associatedConditionLink : some View {
        
        var localNegatives = Binding {
            selectedSymptomDescriptors.pertinentNegatives ?? [String]()
        } set: { newValue in
            selectedSymptomDescriptors.pertinentNegatives = newValue
        }
        
        var localAssociations = Binding {
            selectedSymptomDescriptors.associatedSymptoms  ?? [String]()
        } set: { newValue in
            selectedSymptomDescriptors.associatedSymptoms = newValue
        }

        
        
        return NavigationLink {
            Form{
                if let selectedSymptom {
                    Section("Associated Conditions") {
                        ForEach(selectedSymptom.associatedSymptomChoices, id:\.self) { (association : String) in
                            HStack {
                                Text(association)
                                Spacer()
                                Button("Yes") {
                                    if localNegatives.wrappedValue.contains(association) {
                                        localNegatives.wrappedValue = localNegatives.wrappedValue.filter({$0 != association})
                                    }
                                    if localAssociations.wrappedValue.contains(association) {
                                        localAssociations.wrappedValue = localAssociations.wrappedValue.filter({$0 != association})
                                    }
                                    else {
                                        localAssociations.wrappedValue += [association]
                                    }
                                }.buttonStyle(.borderless)
                                    .fontWeight(localAssociations.wrappedValue.contains(association) ? .heavy : .regular)
                                
                                    .padding()
                                    .background {
                                        localAssociations.wrappedValue.contains(association) ? Color(.systemGroupedBackground) : Color.clear
                                    }
                                
                                
                                
                                Button("No") {
                                    if localAssociations.wrappedValue.contains(association) {
                                        localAssociations.wrappedValue = localAssociations.wrappedValue.filter({$0 != association})
                                    }
                                    if localNegatives.wrappedValue.contains(association) {
                                        localNegatives.wrappedValue = localNegatives.wrappedValue.filter({$0 != association})
                                    }
                                    else {
                                        localNegatives.wrappedValue += [association]
                                    }
                                }.buttonStyle(.borderless)
                                    .padding()
                                    .background {
                                        localNegatives.wrappedValue.contains(association) ? Color(.systemGroupedBackground) : Color.clear
                                    }
                                    .fontWeight(localNegatives.wrappedValue.contains(association) ? .heavy : .regular)
                                
                                
                            }
                            
                        }
                        
                    }
                    Section("Add New Option:") {
                        HStack {
                            TextField("Add Associated Symptom", text: $optionToAdd, prompt: Text("Add Associated Symptom"))
                            Spacer()
                            Button("Add", systemImage: "plus") {
                                if !optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    selectedSymptom.associatedSymptomChoices += [optionToAdd.trimmingCharacters(in: .whitespacesAndNewlines)]
                                    optionToAdd = ""
                                    symptomChoices.saveSymptoms()
                                }
                                
                            }.labelStyle(.iconOnly)
                                .buttonStyle(.borderless)
                        }
                    }
                }
            }
            
        } label: {
            VStack(alignment: .leading){
                Text("Associated Conditions: \(localAssociations.wrappedValue.formatted())")
                Text("Pertinent Negatives: \(localNegatives.wrappedValue.formatted())")
            }.multilineTextAlignment(.leading)
        }
        
    }
    
    
    
    var toggleHasLocation : some View {
        
        let localBool = Binding {
            if let hasLocation = selectedSymptom?.hasLocation {
                return hasLocation
            } else {
                return false
            }
            
        } set: { newValue in
            selectedSymptom?.hasLocation = newValue
            symptomChoices.saveSymptoms()
        }
        
        
        return Toggle("has location", isOn: localBool)
    }
    
    
    var filteredSymptoms : [Symptom] {
        return symptomChoices.symptoms.filter({$0.symptom.localizedStandardContains(searchText)})
    }
    
    func resetSelections() {
//        selectedSymptom = nil
//        selectedCharacter = ""
//        selectedLocation = ""
//        selectedOnsetUnits = ""
//        selectedOnset = 0
//        selectedDuration = 0
//        selectedDurationUnits = ""
//        selectedTiming = ""
//        selectedAggrevators = [String]()
//        selectedRelievers = [String]()
//        selectedSeverity = ""
//        associatedConditions = [String]()
//        pertinentNegatives = [String]()
//        other = ""
        
        selectedSymptomDescriptors = SymptomDescriptors()
        
    }
    
}

#Preview {
    ContentView()
}
