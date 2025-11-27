import SwiftUI

// MARK: - Weight Wheel Picker

struct WeightWheelPicker: View {
    @Binding var weight: Double
    let range: ClosedRange<Double>
    let step: Double

    init(weight: Binding<Double>, range: ClosedRange<Double> = 40...200, step: Double = 0.1) {
        self._weight = weight
        self.range = range
        self.step = step
    }

    private var integerPart: Int {
        Int(weight)
    }

    private var decimalPart: Int {
        Int((weight - Double(integerPart)) * 10)
    }

    private var integers: [Int] {
        Array(Int(range.lowerBound)...Int(range.upperBound))
    }

    private var decimals: [Int] {
        Array(0...9)
    }

    var body: some View {
        HStack(spacing: 0) {
            // Integer picker
            Picker("", selection: Binding(
                get: { integerPart },
                set: { newValue in
                    weight = Double(newValue) + Double(decimalPart) / 10.0
                }
            )) {
                ForEach(integers, id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            .clipped()

            Text(".")
                .font(.title)
                .fontWeight(.medium)

            // Decimal picker
            Picker("", selection: Binding(
                get: { decimalPart },
                set: { newValue in
                    weight = Double(integerPart) + Double(newValue) / 10.0
                }
            )) {
                ForEach(decimals, id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 60)
            .clipped()

            Text("kg")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
        .frame(height: 150)
    }
}

// MARK: - Value Wheel Picker (for checkpoint settings)

struct ValueWheelPicker: View {
    @Binding var value: Double
    let type: ValueType

    enum ValueType {
        case kg
        case percent
    }

    private var values: [Double] {
        switch type {
        case .kg:
            return stride(from: 0.5, through: 10.0, by: 0.5).map { $0 }
        case .percent:
            return [1, 2, 3, 4, 5, 7, 10, 15, 20]
        }
    }

    var body: some View {
        Picker("", selection: $value) {
            ForEach(values, id: \.self) { val in
                Text(formatValue(val))
                    .tag(val)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 150)
    }

    private func formatValue(_ val: Double) -> String {
        switch type {
        case .kg:
            if val == val.rounded() {
                return String(format: "%.0f kg", val)
            }
            return String(format: "%.1f kg", val)
        case .percent:
            return String(format: "%.0f %%", val)
        }
    }
}

// MARK: - Amount Wheel Picker (for reward amount)

struct AmountWheelPicker: View {
    @Binding var amount: Int
    let type: AmountType

    enum AmountType {
        case meals
        case days
    }

    private var values: [Int] {
        Array(1...5)
    }

    var body: some View {
        Picker("", selection: $amount) {
            ForEach(values, id: \.self) { val in
                Text(formatAmount(val))
                    .tag(val)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 150)
    }

    private func formatAmount(_ val: Int) -> String {
        switch type {
        case .meals:
            return val == 1 ? "1 meal" : "\(val) meals"
        case .days:
            return val == 1 ? "1 day" : "\(val) days"
        }
    }
}

#Preview("Weight Picker") {
    struct PreviewWrapper: View {
        @State private var weight: Double = 75.5

        var body: some View {
            VStack {
                Text("Weight: \(String(format: "%.1f", weight)) kg")
                    .font(.headline)

                WeightWheelPicker(weight: $weight)
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
    return PreviewWrapper()
}

#Preview("Value Picker") {
    struct PreviewWrapper: View {
        @State private var value: Double = 2.0

        var body: some View {
            VStack {
                Text("Value: \(String(format: "%.1f", value))")
                    .font(.headline)

                ValueWheelPicker(value: $value, type: .kg)
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
    return PreviewWrapper()
}
