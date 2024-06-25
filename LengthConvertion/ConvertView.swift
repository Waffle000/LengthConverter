//
//  ContentView.swift
//  LengthConvertion
//
//  Created by Enrico Maricar on 25/06/24.
//

import SwiftUI
import Combine

struct ConvertView: View {
    @State private var selectedUnit: LengthUnit = .m
    @State private var targetUnit: LengthUnit = .cm
    @State private var lengthInput: String = ""
    @State private var isValidInput: Bool = true
    @State private var convertedLength: Double = 0.0
    @State private var localeDecimalSeparator: String = Locale.current.decimalSeparator ?? ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Color.blue.opacity(0.7).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Length Converter")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding(.top, 8)
                        
                        HStack {
                            TextField("", text: $lengthInput)
                                .placeholder(when: lengthInput.isEmpty) {
                                    Text("Number").foregroundColor(.white.opacity(0.3))
                                }
                                .keyboardType(.decimalPad)
                                .frame(width: 248)
                                .padding(.leading, 8)
                                .foregroundColor(.white)
                                .accentColor(.white)
                                .onChange(of: lengthInput) { oldValue, newValue in
                                    let filteredValue = newValue.filter { "0123456789\(localeDecimalSeparator)".contains($0) }
                                    if validateInput(filteredValue) {
                                        let formattedValue = formatNumber(filteredValue)
                                        lengthInput = formattedValue
                                        convertLength()
                                    } else if filteredValue.isEmpty {
                                        lengthInput = ""
                                        convertedLength = 0.0
                                    } else {
                                        lengthInput = oldValue
                                    }
                                }
                                .font(.system(size: 48, weight: .bold))
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(isValidInput ? .white : .red)
                                    }
                                )
                                .onReceive(Just(lengthInput)) { _ in limitText(9) }
                            
                            Picker("Select a Length Unit", selection: $selectedUnit) {
                                ForEach(LengthUnit.allCases) { unit in
                                    Text(unit.rawValue)
                                        .tag(unit)
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onChange(of: selectedUnit) { oldValue, newValue in
                                convertLength()
                            }
                        }.padding(.horizontal, 16).padding(.top, 16)
                    }
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height / 2.2)
                
                ZStack(alignment: .top) {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Converted Length")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                            .foregroundStyle(Color.blue.opacity(0.7))
                        
                        HStack {
                            Text("\(formattedConvertedLength())")
                                .font(.system(size: 48, weight: .bold))
                                .frame(width: 248, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.blue.opacity(0.7))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Picker("Select a Length Unit", selection: $targetUnit) {
                                ForEach(LengthUnit.allCases) { unit in
                                    Text(unit.rawValue)
                                        .tag(unit)
                                        .foregroundColor(.blue.opacity(0.7))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onChange(of: targetUnit) { oldValue, newValue in
                                convertLength()
                            }
                        }.padding(.horizontal, 16).padding(.top, 16)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height / 2.2)
                
                Button(action: {
                    selectedUnit = .m
                    targetUnit = .cm
                    lengthInput = ""
                    isValidInput = true
                    convertedLength = 0.0
                }, label: {
                    Text("Reset").font(.title3).fontWeight(.bold ).foregroundStyle(Color.white).padding().frame(maxWidth: .infinity).background(Color.blue.opacity(0.7)).cornerRadius(16).padding(.horizontal, 16)
                })
            }
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    private func validateInput(_ input: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        if let _ = formatter.number(from: input) {
            return true
        } else {
            return false
        }
    }
    
    func limitText(_ upper: Int) {
          if lengthInput.count > upper {
              lengthInput = String(lengthInput.prefix(upper))
          }
      }
    
    private func formatNumber(_ input: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = localeDecimalSeparator
        if let number = formatter.number(from: input) {
            return formatter.string(from: number) ?? input
        }
        return input
    }
    
    private func formattedConvertedLength() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale.current
        if let formattedString = formatter.string(from: NSNumber(value: convertedLength)) {
            return formattedString
        } else {
            return "0"
        }
    }
    
    private func convertLength() {
        guard isValidInput, let length = convertToDouble(lengthInput) else {
            convertedLength = 0.0
            return
        }
        let lengthInMeters = length * selectedUnit.conversionFactorToMeter
        convertedLength = lengthInMeters / targetUnit.conversionFactorToMeter
    }
    
    private func convertToDouble(_ input: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.number(from: input)?.doubleValue
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func placeholder<Content: View>(
           when shouldShow: Bool,
           alignment: Alignment = .leading,
           @ViewBuilder placeholder: () -> Content) -> some View {

           ZStack(alignment: alignment) {
               placeholder().opacity(shouldShow ? 1 : 0)
               self
           }
       }
}

#Preview {
    ConvertView()
}
