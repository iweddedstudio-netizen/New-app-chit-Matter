import SwiftUI

struct CelebrationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 100))
                .foregroundStyle(.yellow)
                .symbolEffect(.bounce, value: true)
            
            VStack(spacing: 16) {
                Text("Checkpoint Reached!")
                    .font(.largeTitle)
                    .bold()
                
                Text("You've unlocked a new reward. Keep up the great work!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Awesome!")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    CelebrationSheet()
        .preferredColorScheme(.dark)
}
