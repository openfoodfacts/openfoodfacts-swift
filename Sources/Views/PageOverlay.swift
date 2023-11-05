import SwiftUI

struct PageOverlay: View {
    
    static let completedAnimDuration = 1.5
    
    static let iconSize = 44.0
    static let circleStrokeWidth = 7.0
    static let dotsSize = 12.0
    static let dotsSpace = 8.0
    
    @Binding var state: ProductPageState
    
    var stateAfterCompleted: ProductPageState = .productDetails
    
    @State private var rotation: Double = 0
    @State private var currentlyAnimatingIndex = 0
    
    private let animationDuration: Double = 0.7
    private let dots = 3
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
        }
        .overlay(
            progressView()
                .frame(width: 150, height: 150, alignment: .center)
        )
    }
    
    @ViewBuilder
    func progressView() -> some View {
        switch state {
        case .loading:
            LoadingCircle(color: .green, rotation: $rotation, autoRepeat: true, trimEnd: 0.3)
            LoadingDots(animationDuration: animationDuration, dots: dots, currentlyAnimatingIndex: $currentlyAnimatingIndex)
        case .completed:
            LoadingCircle(color: .green, rotation: $rotation, autoRepeat: false, trimEnd: 0.3 + CGFloat(rotation / 360))
            CompletedCheckmark(rotation: $rotation)
//        case .error:
//            ErrorCircle()
//            ErrorMark()
        case .productDetails: 
            EmptyView()
        }
    }
}

struct LoadingCircle: View {
    var color: Color
    @Binding var rotation: Double
    var autoRepeat: Bool
    var trimEnd: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: 0, to: trimEnd)
            .stroke(color, lineWidth: PageOverlay.circleStrokeWidth)
            .rotationEffect(.degrees(rotation))
            .padding(20)
            .onAppear {
                let animation = Animation.easeOut(duration: 0.8)
                withAnimation(autoRepeat ? animation.repeatForever(autoreverses: false) : animation) {
                    rotation = 360
                }
            }
    }
}

struct LoadingDots: View {
    let animationDuration: Double
    let dots: Int
    @Binding var currentlyAnimatingIndex: Int
    
    var body: some View {
        HStack(spacing: PageOverlay.dotsSpace) {
            ForEach(0..<dots, id: \.self) { index in
                Circle()
                    .foregroundColor(.white)
                    .frame(width: PageOverlay.dotsSize, height: PageOverlay.dotsSize)
                    .scaleEffect(currentlyAnimatingIndex == index ? 1.3 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: animationDuration)
                            .repeatForever(autoreverses: true),
                        value: currentlyAnimatingIndex == index
                    )
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: animationDuration / Double(dots), repeats: true) { _ in
                currentlyAnimatingIndex = (currentlyAnimatingIndex + 1) % dots
            }
        }
    }
}

struct CompletedCheckmark: View {
    @Binding var rotation: Double
    
    var body: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.green)
            .font(.system(size: PageOverlay.iconSize, weight: .bold))
            .clipShape(
                Rectangle()
                    .offset(y: PageOverlay.iconSize - PageOverlay.iconSize * CGFloat(rotation / 360))
            )
            .onAppear {
                withAnimation(
                    Animation.easeOut(duration: PageOverlay.completedAnimDuration * 0.7)
                        .delay(PageOverlay.completedAnimDuration * 0.3)
                ) {
                    rotation = 360
                }
            }
    }
}

struct ErrorCircle: View {
    var body: some View {
        Circle()
            .stroke(Color.red, lineWidth: PageOverlay.circleStrokeWidth)
            .padding(20)
    }
}

struct ErrorMark: View {
    
    var body: some View {
        Image(systemName: "xmark")
            .foregroundColor(.red)
            .font(.system(size: PageOverlay.iconSize, weight: .bold))
    }
}

#Preview {
    PageOverlay(state: .constant(.loading))
}
