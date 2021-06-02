//
//  ContentView.swift
//  Coffee-and-Sleep
//
//  Created by Loi Pham on 5/31/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private var alert: [String: String] {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return ["alertMessage": formatter.string(from: sleepTime),             "alertTitle" : "Your ideal bedtime is... "]
            
        } catch {
            return ["alertTitle": "Error", "alertMessage": "Sorry, there was a problem calculating your bedtime."]
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
//                    Text("Daily coffee intake")
//                        .font(.headline)
//
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
                    
                    Picker(selection: $coffeeAmount, label: Text("Daily coffee intake")) {
                        ForEach(1..<21) { cup in
                            if cup == 1 {
                                Text("\(cup) cup")
                            } else {
                                Text("\(cup) cups")
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text(alert["alertTitle"]!)
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text(alert["alertMessage"]!)
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                
            } // FORM
            .navigationBarTitle("Coffee and Sleep")
//            .navigationBarItems(trailing: Button(action: calculateBedtime) {
//                Text("Calculate")
//            })
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        } // NAVIGATION VIEW
    } // BODY
    
//    func calculateBedtime() {
//        let model = SleepCalculator()
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is ... "
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }
//
//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
