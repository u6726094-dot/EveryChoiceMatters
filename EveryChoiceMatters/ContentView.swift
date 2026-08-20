//
//  ContentView.swift
//  EveryChoiceMatters
//
//  Created by sherlock on 14/7/2569 BE.
//

import SwiftUI

// MARK: - Main Navigation

struct ContentView: View {

    enum JourneyScene {
        case welcome
        case flower
        case bird
        case river
        case lantern
        case ending
    }

    @State private var currentScene: JourneyScene = .welcome

    var body: some View {
        ZStack {
            switch currentScene {
            case .welcome:
                WelcomeView {
                    moveTo(.flower)
                }

            case .flower:
                FlowerSceneView {
                    moveTo(.bird)
                }

            case .bird:
                BirdSceneView {
                    moveTo(.river)
                }

            case .river:
                RiverSceneView {
                    moveTo(.lantern)
                }

            case .lantern:
                LanternSceneView {
                    moveTo(.ending)
                }

            case .ending:
                EndingView {
                    moveTo(.welcome)
                }
            }
        }
        .animation(.easeInOut(duration: 0.45), value: currentScene)
    }

    private func moveTo(_ scene: JourneyScene) {
        withAnimation(.easeInOut(duration: 0.45)) {
            currentScene = scene
        }
    }
}

// MARK: - Welcome Screen

struct WelcomeView: View {

    let onBegin: () -> Void

    @State private var sparkleScale: CGFloat = 0.85

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.20),
                    Color(red: 0.22, green: 0.12, blue: 0.48)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 26) {
                Spacer()

                Image(systemName: "sparkles")
                    .font(.system(size: 72))
                    .foregroundStyle(.yellow)
                    .scaleEffect(sparkleScale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.4)
                            .repeatForever(autoreverses: true)
                        ) {
                            sparkleScale = 1.15
                        }
                    }
                    .accessibilityHidden(true)

                Text("Every Choice Matters")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text("Small actions can change the world.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.82))

                Spacer()

                PrimaryButton(
                    title: "Begin the Journey",
                    action: onBegin
                )
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 24)
        }
    }
}

// MARK: - Flower Scene

struct FlowerSceneView: View {

    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    @State private var bucketOffset: CGSize = .zero
    @State private var flowerBloomed = false
    @State private var showWater = false
    @State private var showContinue = false

    // Wind animation states
    @State private var windBlowing = false
    @State private var floatingLeafX: CGFloat = -230
    @State private var secondLeafX: CGFloat = -280

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                gardenBackground

                blowingLeaves(
                    screenWidth: geometry.size.width
                )

                VStack(spacing: 14) {
                    flowerHeader

                    Spacer(minLength: 4)

                    gardenContent(
                        width: geometry.size.width
                    )

                    bottomControl
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 14)
            }
            .onAppear {
                startWindAnimation(
                    screenWidth: geometry.size.width
                )
            }
        }
        .transition(.opacity)
    }

    // MARK: - Background

    private var gardenBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(
                        red: 0.55,
                        green: 0.84,
                        blue: 0.98
                    ),
                    Color(
                        red: 0.79,
                        green: 0.95,
                        blue: 0.91
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                Spacer()

                RoundedRectangle(cornerRadius: 70)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0.32,
                                    green: 0.72,
                                    blue: 0.38
                                ),
                                Color(
                                    red: 0.18,
                                    green: 0.53,
                                    blue: 0.27
                                )
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 255)
                    .offset(y: 95)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Flying Leaves

    private func blowingLeaves(
        screenWidth: CGFloat
    ) -> some View {
        ZStack {
            Image(systemName: "leaf.fill")
                .font(.system(size: 25))
                .foregroundStyle(
                    Color(
                        red: 0.62,
                        green: 0.40,
                        blue: 0.22
                    )
                )
                .rotationEffect(
                    .degrees(windBlowing ? 300 : -20)
                )
                .offset(
                    x: floatingLeafX,
                    y: windBlowing ? 40 : -35
                )

            Image(systemName: "leaf.fill")
                .font(.system(size: 18))
                .foregroundStyle(
                    Color.orange.opacity(0.75)
                )
                .rotationEffect(
                    .degrees(windBlowing ? -260 : 25)
                )
                .offset(
                    x: secondLeafX,
                    y: windBlowing ? -5 : 55
                )

            Image(systemName: "leaf.fill")
                .font(.system(size: 14))
                .foregroundStyle(
                    Color.green.opacity(0.65)
                )
                .rotationEffect(
                    .degrees(windBlowing ? 210 : -40)
                )
                .offset(
                    x: floatingLeafX - 80,
                    y: windBlowing ? 90 : 25
                )
        }
        .frame(
            width: screenWidth,
            height: 420
        )
        .offset(y: 180)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Header

    private var flowerHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Label(
                    "Choice 1 of 4",
                    systemImage: "leaf.fill"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(.green)

                Spacer()
            }

            Text("A Thirsty Flower")
                .font(
                    .system(
                        size: 27,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.10,
                        green: 0.28,
                        blue: 0.23
                    )
                )
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            Text(
                flowerBloomed
                ? "Your small act of care helped the flower bloom."
                : "Drag the water bucket toward the flower."
            )
            .font(
                .system(
                    size: 15,
                    weight: .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(
                Color(
                    red: 0.19,
                    green: 0.41,
                    blue: 0.35
                )
            )
            .multilineTextAlignment(.center)
            .lineLimit(2)
        }
        .padding(17)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.91))
        .clipShape(
            RoundedRectangle(cornerRadius: 23)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Garden Layout

    private func gardenContent(
        width: CGFloat
    ) -> some View {
        ZStack(alignment: .bottom) {
            gardenGround

            HStack(
                alignment: .bottom,
                spacing: 0
            ) {
                flowerView
                    .frame(maxWidth: .infinity)

                bucketView(
                    maximumDrag: width * 0.44
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 45)
        }
        .frame(maxWidth: .infinity)
        .frame(
            height: min(
                380,
                width * 0.92
            )
        )
        .clipped()
    }

    // MARK: - Windy Grass

    private var gardenGround: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(
                alignment: .bottom,
                spacing: 5
            ) {
                ForEach(
                    0..<34,
                    id: \.self
                ) { index in
                    Capsule()
                        .fill(
                            index.isMultiple(of: 2)
                            ? Color.green
                            : Color.green.opacity(0.70)
                        )
                        .frame(
                            width: 4,
                            height: CGFloat(
                                13 + (index % 4) * 5
                            )
                        )
                        .rotationEffect(
                            .degrees(
                                grassRotation(
                                    for: index
                                )
                            ),
                            anchor: .bottom
                        )
                        .animation(
                            reduceMotion
                            ? nil
                            : .easeInOut(
                                duration:
                                    0.75 +
                                    Double(index % 5) * 0.08
                            )
                            .repeatForever(
                                autoreverses: true
                            )
                            .delay(
                                Double(index % 7) * 0.04
                            ),
                            value: windBlowing
                        )
                }
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(
                    Color(
                        red: 0.22,
                        green: 0.62,
                        blue: 0.30
                    )
                )
                .frame(height: 95)
        }
    }

    private func grassRotation(
        for index: Int
    ) -> Double {
        guard !reduceMotion else {
            return index.isMultiple(of: 2)
            ? -7
            : 7
        }

        if windBlowing {
            return Double(
                12 + index % 7
            )
        }

        return Double(
            -10 + index % 5
        )
    }

    // MARK: - Flower

    private var flowerView: some View {
        VStack(spacing: -3) {
            ZStack {
                if flowerBloomed {
                    ForEach(
                        0..<8,
                        id: \.self
                    ) { index in
                        Ellipse()
                            .fill(
                                index.isMultiple(of: 2)
                                ? Color.pink
                                : Color.orange
                            )
                            .frame(
                                width: 34,
                                height: 48
                            )
                            .offset(y: -20)
                            .rotationEffect(
                                .degrees(
                                    Double(index) * 45
                                )
                            )
                    }

                    Circle()
                        .fill(.yellow)
                        .frame(
                            width: 38,
                            height: 38
                        )
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 43))
                        .foregroundStyle(.brown)
                        .rotationEffect(
                            .degrees(-12)
                        )
                }

                if showWater {
                    HStack(spacing: 4) {
                        ForEach(
                            0..<3,
                            id: \.self
                        ) { _ in
                            Image(
                                systemName: "drop.fill"
                            )
                            .foregroundStyle(.cyan)
                        }
                    }
                    .font(.system(size: 16))
                    .offset(
                        x: 62,
                        y: -35
                    )
                }
            }
            .frame(
                width: 100,
                height: 100
            )
            .scaleEffect(
                flowerBloomed ? 1 : 0.76
            )
            .rotationEffect(
                .degrees(
                    reduceMotion
                    ? 0
                    : windBlowing
                    ? 4
                    : -4
                ),
                anchor: .bottom
            )
            .animation(
                .spring(
                    response: 0.75,
                    dampingFraction: 0.58
                ),
                value: flowerBloomed
            )
            .animation(
                reduceMotion
                ? nil
                : .easeInOut(duration: 1.15)
                    .repeatForever(
                        autoreverses: true
                    ),
                value: windBlowing
            )

            flowerStem

            Ellipse()
                .fill(
                    Color(
                        red: 0.48,
                        green: 0.28,
                        blue: 0.14
                    )
                )
                .frame(
                    width: 125,
                    height: 35
                )
        }
        .frame(width: 140)
        .accessibilityLabel(
            flowerBloomed
            ? "A colorful blooming flower moving gently in the wind"
            : "A dry flower waiting for water"
        )
    }

    private var flowerStem: some View {
        ZStack {
            Capsule()
                .fill(.green)
                .frame(
                    width: 10,
                    height: 108
                )

            Image(systemName: "leaf.fill")
                .font(.system(size: 29))
                .foregroundStyle(.green)
                .rotationEffect(
                    .degrees(
                        windBlowing
                        ? -8
                        : -25
                    ),
                    anchor: .trailing
                )
                .offset(
                    x: -19,
                    y: -15
                )
                .animation(
                    reduceMotion
                    ? nil
                    : .easeInOut(duration: 0.95)
                        .repeatForever(
                            autoreverses: true
                        ),
                    value: windBlowing
                )

            Image(systemName: "leaf.fill")
                .font(.system(size: 27))
                .foregroundStyle(
                    .green.opacity(0.85)
                )
                .rotationEffect(
                    .degrees(
                        windBlowing
                        ? 180
                        : 205
                    ),
                    anchor: .leading
                )
                .offset(
                    x: 19,
                    y: 15
                )
                .animation(
                    reduceMotion
                    ? nil
                    : .easeInOut(duration: 1.05)
                        .repeatForever(
                            autoreverses: true
                        ),
                    value: windBlowing
                )
        }
        .rotationEffect(
            .degrees(
                reduceMotion
                ? 0
                : windBlowing
                ? 3
                : -3
            ),
            anchor: .bottom
        )
        .animation(
            reduceMotion
            ? nil
            : .easeInOut(duration: 1.2)
                .repeatForever(
                    autoreverses: true
                ),
            value: windBlowing
        )
    }

    // MARK: - Bucket

    private func bucketView(
        maximumDrag: CGFloat
    ) -> some View {
        CuteWaterBucket()
            .frame(
                width: 100,
                height: 110
            )
            .offset(bucketOffset)
            .rotationEffect(
                .degrees(
                    bucketOffset.width < -35
                    ? -18
                    : 0
                )
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !flowerBloomed else {
                            return
                        }

                        let limitedX = min(
                            max(
                                value.translation.width,
                                -maximumDrag
                            ),
                            10
                        )

                        let limitedY = min(
                            max(
                                value.translation.height,
                                -45
                            ),
                            45
                        )

                        bucketOffset = CGSize(
                            width: limitedX,
                            height: limitedY
                        )

                        showWater = limitedX < -60
                    }
                    .onEnded { value in
                        guard !flowerBloomed else {
                            return
                        }

                        if value.translation.width < -85 {
                            waterFlower()
                        } else {
                            resetBucket()
                        }
                    }
            )
            .accessibilityLabel(
                "Cute blue water bucket"
            )
            .accessibilityHint(
                "Drag the bucket toward the flower"
            )
    }

    // MARK: - Bottom Control

    @ViewBuilder
    private var bottomControl: some View {
        if showContinue {
            PrimaryButton(
                title: "Continue the Journey",
                action: onComplete
            )
            .transition(
                .move(edge: .bottom)
                .combined(with: .opacity)
            )
        } else {
            HStack(spacing: 8) {
                Image(
                    systemName: "hand.draw.fill"
                )

                Text(
                    "Drag the bucket toward the flower"
                )
            }
            .font(
                .system(
                    size: 14,
                    weight: .semibold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(.black.opacity(0.22))
            .clipShape(Capsule())
        }
    }

    // MARK: - Actions

    private func waterFlower() {
        withAnimation(
            .easeInOut(duration: 0.25)
        ) {
            showWater = true

            bucketOffset = CGSize(
                width: -88,
                height: 0
            )
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.35
        ) {
            withAnimation(
                .spring(
                    response: 0.75,
                    dampingFraction: 0.58
                )
            ) {
                flowerBloomed = true
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.0
        ) {
            withAnimation(.spring()) {
                bucketOffset = .zero
                showWater = false
                showContinue = true
            }
        }
    }

    private func resetBucket() {
        withAnimation(.spring()) {
            bucketOffset = .zero
            showWater = false
        }
    }

    private func startWindAnimation(
        screenWidth: CGFloat
    ) {
        guard !reduceMotion else {
            return
        }

        windBlowing = false
        floatingLeafX = -screenWidth
        secondLeafX = -screenWidth - 80

        withAnimation(
            .easeInOut(duration: 1.15)
            .repeatForever(
                autoreverses: true
            )
        ) {
            windBlowing = true
        }

        withAnimation(
            .linear(duration: 7)
            .repeatForever(
                autoreverses: false
            )
        ) {
            floatingLeafX = screenWidth + 120
        }

        withAnimation(
            .linear(duration: 9)
            .repeatForever(
                autoreverses: false
            )
            .delay(1.4)
        ) {
            secondLeafX = screenWidth + 150
        }
    }
}

// MARK: - Cute Water Bucket

struct CuteWaterBucket: View {

    var body: some View {
        ZStack {
            Circle()
                .trim(
                    from: 0.08,
                    to: 0.92
                )
                .stroke(
                    Color(
                        red: 0.18,
                        green: 0.40,
                        blue: 0.55
                    ),
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round
                    )
                )
                .frame(
                    width: 72,
                    height: 72
                )
                .offset(y: -25)

            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color(
                            red: 0.48,
                            green: 0.85,
                            blue: 0.96
                        ),
                        Color(
                            red: 0.15,
                            green: 0.55,
                            blue: 0.78
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(
                width: 84,
                height: 70
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 20
                )
                .stroke(
                    .white.opacity(0.45),
                    lineWidth: 3
                )
            }
            .offset(y: 16)

            Capsule()
                .fill(
                    Color(
                        red: 0.12,
                        green: 0.38,
                        blue: 0.54
                    )
                )
                .frame(
                    width: 82,
                    height: 17
                )
                .offset(y: -16)

            Capsule()
                .fill(.cyan.opacity(0.80))
                .frame(
                    width: 65,
                    height: 9
                )
                .offset(y: -16)

            HStack(spacing: 20) {
                Circle()
                    .fill(
                        Color(
                            red: 0.10,
                            green: 0.25,
                            blue: 0.30
                        )
                    )
                    .frame(
                        width: 7,
                        height: 7
                    )

                Circle()
                    .fill(
                        Color(
                            red: 0.10,
                            green: 0.25,
                            blue: 0.30
                        )
                    )
                    .frame(
                        width: 7,
                        height: 7
                    )
            }
            .offset(y: 14)

            SmileShape()
                .stroke(
                    Color(
                        red: 0.10,
                        green: 0.25,
                        blue: 0.30
                    ),
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .frame(
                    width: 18,
                    height: 10
                )
                .offset(y: 27)

            Capsule()
                .fill(.white.opacity(0.45))
                .frame(
                    width: 9,
                    height: 27
                )
                .rotationEffect(
                    .degrees(12)
                )
                .offset(
                    x: -27,
                    y: 11
                )
        }
    }
}

// MARK: - Smile Shape

struct SmileShape: Shape {

    func path(
        in rect: CGRect
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        )

        return path
    }
}
// MARK: - Bird Scene

struct BirdSceneView: View {

    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    @State private var cageUnlocked = false
    @State private var cageDoorOpen = false
    @State private var birdHasFlown = false

    @State private var birdOffset: CGSize = .zero
    @State private var birdRotation: Double = 0
    @State private var birdScale: CGFloat = 1
    @State private var wingUp = false

    @State private var showContinue = false
    @State private var lockBounce = false

    // Nature animation
    @State private var firstCloudX: CGFloat = -230
    @State private var secondCloudX: CGFloat = -260
    @State private var thirdCloudX: CGFloat = -290
    @State private var windX: CGFloat = -260
    @State private var leafX: CGFloat = -250
    @State private var doveSway = false

    var body: some View {
        SceneBackground(
            colors: [
                Color(red: 0.48, green: 0.82, blue: 0.97),
                Color(red: 0.75, green: 0.94, blue: 0.92)
            ]
        ) {
            VStack(spacing: 18) {
                StoryHeader(
                    progress: "Choice 2 of 4",
                    title: "A Dove in a Cage",
                    instruction: birdHasFlown
                    ? "Your choice gave the dove its freedom."
                    : cageUnlocked
                    ? "The cage is open. Watch the dove fly."
                    : "Tap the golden lock to open the cage."
                )

                Spacer(minLength: 8)

                cageScene

                Spacer(minLength: 8)

                bottomControl
            }
        }
        .transition(.opacity)
    }

    // MARK: - Main Scene

    private var cageScene: some View {
        GeometryReader { geometry in
            ZStack {
                movingClouds(
                    sceneWidth: geometry.size.width
                )
                .zIndex(0)

                windLayer(
                    sceneWidth: geometry.size.width
                )
                .zIndex(1)

                Ellipse()
                    .fill(.black.opacity(0.12))
                    .frame(width: 220, height: 32)
                    .offset(y: 155)
                    .zIndex(2)

                cageBack
                    .zIndex(3)

                doveView
                    .zIndex(4)

                cageFrontBars
                    .zIndex(5)

                cageDoor
                    .zIndex(6)

                lockButton
                    .zIndex(7)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .onAppear {
                startNatureAnimations(
                    sceneWidth: geometry.size.width
                )
            }
        }
        .frame(height: 430)
        .clipped()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Moving Clouds

    private func movingClouds(
        sceneWidth: CGFloat
    ) -> some View {
        ZStack {
            DoveCloud(scale: 0.52)
                .offset(
                    x: firstCloudX,
                    y: -145
                )

            DoveCloud(scale: 0.40)
                .opacity(0.78)
                .offset(
                    x: secondCloudX,
                    y: -100
                )

            DoveCloud(scale: 0.30)
                .opacity(0.62)
                .offset(
                    x: thirdCloudX,
                    y: -45
                )
        }
        .frame(
            width: sceneWidth,
            height: 430
        )
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Wind

    private func windLayer(
        sceneWidth: CGFloat
    ) -> some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(.white.opacity(0.28))
                    .frame(
                        width: CGFloat(45 + index * 10),
                        height: 3
                    )
                    .offset(
                        x: windX - CGFloat(index * 75),
                        y: CGFloat(-95 + index * 47)
                    )
            }

            ForEach(0..<3, id: \.self) { index in
                Image(systemName: "leaf.fill")
                    .font(
                        .system(
                            size: CGFloat(13 + index * 3)
                        )
                    )
                    .foregroundStyle(
                        index.isMultiple(of: 2)
                        ? Color.green.opacity(0.65)
                        : Color.orange.opacity(0.64)
                    )
                    .rotationEffect(
                        .degrees(
                            leafX > 0
                            ? 320
                            : -25
                        )
                    )
                    .offset(
                        x: leafX - CGFloat(index * 95),
                        y: CGFloat(-45 + index * 88)
                    )
            }
        }
        .frame(
            width: sceneWidth,
            height: 430
        )
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Cage Back

    private var cageBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34)
                .fill(.black.opacity(0.10))
                .frame(width: 220, height: 255)
                .offset(y: 32)
                .blur(radius: 8)

            Circle()
                .trim(from: 0.50, to: 1)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white,
                            Color(
                                red: 0.90,
                                green: 0.91,
                                blue: 0.93
                            )
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .frame(width: 194, height: 194)
                .offset(y: -53)

            RoundedRectangle(cornerRadius: 30)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white,
                            Color(
                                red: 0.88,
                                green: 0.89,
                                blue: 0.92
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 10
                )
                .frame(width: 194, height: 238)
                .offset(y: 20)

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 0.70,
                                green: 0.48,
                                blue: 0.28
                            ),
                            Color(
                                red: 0.48,
                                green: 0.29,
                                blue: 0.16
                            )
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 125, height: 13)
                .offset(y: 83)

            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            .white,
                            Color(
                                red: 0.88,
                                green: 0.89,
                                blue: 0.92
                            )
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 220, height: 38)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white, lineWidth: 3)
                }
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 5,
                    y: 4
                )
                .offset(y: 142)

            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white,
                            Color(
                                red: 0.86,
                                green: 0.88,
                                blue: 0.91
                            )
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 8
                )
                .frame(width: 58, height: 38)
                .offset(y: -128)
        }
    }

    // MARK: - Front Bars

    private var cageFrontBars: some View {
        HStack(spacing: 22) {
            ForEach(0..<6, id: \.self) { _ in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white,
                                Color(
                                    red: 0.85,
                                    green: 0.87,
                                    blue: 0.90
                                )
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 7, height: 198)
                    .shadow(
                        color: .black.opacity(0.08),
                        radius: 2,
                        x: 1,
                        y: 1
                    )
            }
        }
        .offset(y: 20)
        .allowsHitTesting(false)
    }

    // MARK: - Cage Door

    private var cageDoor: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(.white.opacity(0.16))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.white, lineWidth: 7)

                HStack(spacing: 17) {
                    ForEach(0..<4, id: \.self) { _ in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white,
                                        Color(
                                            red: 0.88,
                                            green: 0.88,
                                            blue: 0.84
                                        )
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 6, height: 124)
                    }
                }
            }
            .frame(width: 112, height: 145)
            .rotation3DEffect(
                .degrees(
                    cageDoorOpen ? -78 : 0
                ),
                axis: (
                    x: 0,
                    y: 1,
                    z: 0
                ),
                anchor: .leading,
                perspective: 0.45
            )
            .offset(x: 35, y: 42)
            .animation(
                .spring(
                    response: 0.8,
                    dampingFraction: 0.72
                ),
                value: cageDoorOpen
            )
    }

    // MARK: - Lock

    private var lockButton: some View {
        Button {
            unlockCage()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .yellow,
                                .orange
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 6
                    )
                    .frame(width: 34, height: 31)
                    .offset(y: -16)

                RoundedRectangle(cornerRadius: 9)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 1.00,
                                    green: 0.82,
                                    blue: 0.22
                                ),
                                Color(
                                    red: 0.88,
                                    green: 0.52,
                                    blue: 0.08
                                )
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(
                                .white.opacity(0.55),
                                lineWidth: 2
                            )
                    }
                    .shadow(
                        color: .orange.opacity(0.35),
                        radius: 7,
                        y: 4
                    )

                Circle()
                    .fill(.brown.opacity(0.75))
                    .frame(width: 8, height: 8)
                    .offset(y: -1)

                Capsule()
                    .fill(.brown.opacity(0.75))
                    .frame(width: 4, height: 11)
                    .offset(y: 7)
            }
        }
        .buttonStyle(.plain)
        .rotationEffect(
            .degrees(
                cageUnlocked ? -18 : 0
            )
        )
        .scaleEffect(
            lockBounce ? 1.12 : 1
        )
        .offset(x: 82, y: 52)
        .disabled(cageUnlocked)
        .accessibilityLabel(
            cageUnlocked
            ? "Cage unlocked"
            : "Golden cage lock"
        )
        .accessibilityHint(
            "Tap to unlock the cage"
        )
    }

    // MARK: - Dove

    private var doveView: some View {
        DoveView(wingUp: wingUp)
            .frame(width: 104, height: 88)
            .scaleEffect(birdScale)
            .rotationEffect(
                .degrees(
                    birdHasFlown
                    ? birdRotation
                    : doveSway ? 2 : -2
                )
            )
            .offset(birdOffset)
            .offset(
                x: -12,
                y: birdHasFlown
                ? 62
                : doveSway ? 59 : 63
            )
            .animation(
                birdHasFlown || reduceMotion
                ? nil
                : .easeInOut(duration: 1.25)
                    .repeatForever(
                        autoreverses: true
                    ),
                value: doveSway
            )
            .accessibilityLabel(
                birdHasFlown
                ? "A dove flying freely"
                : "A dove resting inside the cage"
            )
    }

    // MARK: - Bottom Control

    @ViewBuilder
    private var bottomControl: some View {
        if showContinue {
            PrimaryButton(
                title: "Continue the Journey",
                action: onComplete
            )
            .transition(
                .move(edge: .bottom)
                .combined(with: .opacity)
            )
        } else {
            HStack(spacing: 8) {
                Image(
                    systemName: cageUnlocked
                    ? "sparkles"
                    : "hand.tap.fill"
                )

                Text(
                    cageUnlocked
                    ? "The dove is flying free"
                    : "Tap the golden lock"
                )
            }
            .font(
                .system(
                    size: 14,
                    weight: .semibold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 44)
            .background(.black.opacity(0.20))
            .clipShape(Capsule())
        }
    }

    // MARK: - Actions

    private func unlockCage() {
        guard !cageUnlocked else {
            return
        }

        withAnimation(
            .spring(
                response: 0.4,
                dampingFraction: 0.55
            )
        ) {
            cageUnlocked = true
            lockBounce = true
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.25
        ) {
            withAnimation(.spring()) {
                lockBounce = false
                cageDoorOpen = true
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.95
        ) {
            flyDove()
        }
    }

    private func flyDove() {
        birdHasFlown = true
        wingUp = false

        withAnimation(
            .easeInOut(duration: 0.17)
            .repeatCount(
                14,
                autoreverses: true
            )
        ) {
            wingUp = true
        }

        withAnimation(
            .timingCurve(
                0.18,
                0.72,
                0.24,
                1.0,
                duration: 2.7
            )
        ) {
            birdOffset = CGSize(
                width: 255,
                height: -285
            )

            birdRotation = -10
            birdScale = 0.62
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.9
        ) {
            withAnimation(.easeOut(duration: 0.5)) {
                showContinue = true
            }
        }
    }

    private func startNatureAnimations(
        sceneWidth: CGFloat
    ) {
        guard !reduceMotion else {
            return
        }

        doveSway = false

        firstCloudX = -sceneWidth
        secondCloudX = -sceneWidth - 100
        thirdCloudX = -sceneWidth - 180

        windX = -sceneWidth
        leafX = -sceneWidth - 80

        withAnimation(
            .easeInOut(duration: 1.25)
            .repeatForever(autoreverses: true)
        ) {
            doveSway = true
        }

        withAnimation(
            .linear(duration: 13)
            .repeatForever(autoreverses: false)
        ) {
            firstCloudX = sceneWidth + 170
        }

        withAnimation(
            .linear(duration: 18)
            .repeatForever(autoreverses: false)
            .delay(2)
        ) {
            secondCloudX = sceneWidth + 190
        }

        withAnimation(
            .linear(duration: 22)
            .repeatForever(autoreverses: false)
            .delay(4)
        ) {
            thirdCloudX = sceneWidth + 210
        }

        withAnimation(
            .linear(duration: 4.5)
            .repeatForever(autoreverses: false)
        ) {
            windX = sceneWidth + 300
        }

        withAnimation(
            .linear(duration: 7)
            .repeatForever(autoreverses: false)
            .delay(1)
        ) {
            leafX = sceneWidth + 300
        }
    }
}

// MARK: - Dove

struct DoveView: View {

    let wingUp: Bool

    var body: some View {
        ZStack {
            tailFeathers
            bodyShape
            lowerShade
            wing
            wingLines
            neck
            head
            eye
            beak
            feet
        }
    }

    private var tailFeathers: some View {
        HStack(spacing: -10) {
            DoveFeatherShape()
                .fill(.white.opacity(0.96))
                .frame(width: 42, height: 18)
                .rotationEffect(.degrees(-24))

            DoveFeatherShape()
                .fill(
                    Color(
                        red: 0.88,
                        green: 0.90,
                        blue: 0.93
                    )
                )
                .frame(width: 42, height: 18)

            DoveFeatherShape()
                .fill(.white.opacity(0.96))
                .frame(width: 42, height: 18)
                .rotationEffect(.degrees(24))
        }
        .offset(x: -48, y: 22)
    }

    private var bodyShape: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [
                        .white,
                        Color(
                            red: 0.86,
                            green: 0.89,
                            blue: 0.93
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 90, height: 62)
            .shadow(
                color: .black.opacity(0.12),
                radius: 5,
                y: 3
            )
    }

    private var lowerShade: some View {
        Ellipse()
            .fill(.gray.opacity(0.12))
            .frame(width: 58, height: 34)
            .offset(x: -2, y: 14)
    }

    private var wing: some View {
        DoveWingShape()
            .fill(
                LinearGradient(
                    colors: [
                        .white,
                        Color(
                            red: 0.78,
                            green: 0.82,
                            blue: 0.88
                        )
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 75, height: 46)
            .rotationEffect(
                .degrees(
                    wingUp ? -42 : 10
                ),
                anchor: .leading
            )
            .offset(x: -8, y: -3)
            .animation(
                .easeInOut(duration: 0.16),
                value: wingUp
            )
    }

    private var wingLines: some View {
        VStack(spacing: 5) {
            Capsule()
                .fill(.gray.opacity(0.28))
                .frame(width: 38, height: 2)

            Capsule()
                .fill(.gray.opacity(0.24))
                .frame(width: 32, height: 2)

            Capsule()
                .fill(.gray.opacity(0.20))
                .frame(width: 25, height: 2)
        }
        .rotationEffect(
            .degrees(
                wingUp ? -40 : 8
            )
        )
        .offset(x: -7, y: 1)
    }

    private var neck: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [
                        .white,
                        Color(
                            red: 0.88,
                            green: 0.90,
                            blue: 0.94
                        )
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 48, height: 55)
            .offset(x: 31, y: -19)
    }

    private var head: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        .white,
                        Color(
                            red: 0.88,
                            green: 0.91,
                            blue: 0.95
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 47, height: 47)
            .offset(x: 47, y: -34)
    }

    private var eye: some View {
        ZStack {
            Circle()
                .fill(.black)
                .frame(width: 7, height: 7)

            Circle()
                .fill(.white)
                .frame(width: 2.5, height: 2.5)
                .offset(x: 1, y: -1)
        }
        .offset(x: 58, y: -38)
    }

    private var beak: some View {
        DoveTriangleShape()
            .fill(
                Color(
                    red: 0.82,
                    green: 0.58,
                    blue: 0.30
                )
            )
            .frame(width: 18, height: 12)
            .rotationEffect(.degrees(90))
            .offset(x: 75, y: -31)
    }

    private var feet: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(.orange.opacity(0.80))
                .frame(width: 3, height: 15)

            Capsule()
                .fill(.orange.opacity(0.80))
                .frame(width: 3, height: 15)
        }
        .offset(x: 8, y: 36)
    }
}

// MARK: - Dove Wing Shape

struct DoveWingShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY * 0.72
            ),
            control1: CGPoint(
                x: rect.width * 0.28,
                y: rect.minY
            ),
            control2: CGPoint(
                x: rect.width * 0.75,
                y: rect.minY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            ),
            control1: CGPoint(
                x: rect.width * 0.75,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.width * 0.20,
                y: rect.maxY
            )
        )

        return path
    }
}

// MARK: - Dove Feather Shape

struct DoveFeatherShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.midY
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        )

        return path
    }
}

// MARK: - Dove Beak Shape

struct DoveTriangleShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )

        path.closeSubpath()

        return path
    }
}

// MARK: - Dove Cloud

struct DoveCloud: View {

    let scale: CGFloat

    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.78))
                .frame(width: 150, height: 55)

            Circle()
                .fill(.white.opacity(0.85))
                .frame(width: 65, height: 65)
                .offset(x: -35, y: -17)

            Circle()
                .fill(.white.opacity(0.88))
                .frame(width: 82, height: 82)
                .offset(x: 17, y: -25)
        }
        .scaleEffect(scale)
    }
}
// MARK: - River Scene

struct RiverSceneView: View {

    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    @State private var trashOffset: CGSize = .zero
    @State private var riverClean = false
    @State private var waterFlowOffset: CGFloat = -150
    @State private var trashFloating = false
    @State private var showContinue = false

    var body: some View {
        GeometryReader { geometry in
            SceneBackground(
                colors: [
                    Color(red: 0.39, green: 0.75, blue: 0.95),
                    Color(red: 0.53, green: 0.86, blue: 0.78)
                ]
            ) {
                VStack(spacing: 18) {
                    StoryHeader(
                        progress: "Choice 3 of 4",
                        title: "A Polluted River",
                        instruction: riverClean
                        ? "The river is flowing clean again."
                        : "Drag the floating trash into the bin."
                    )

                    Spacer(minLength: 8)

                    riverArea(
                        width: geometry.size.width - 44
                    )

                    Spacer(minLength: 8)

                    bottomControl
                }
            }
        }
        .transition(.opacity)
    }

    // MARK: - River Area

    private func riverArea(width: CGFloat) -> some View {
        ZStack {
            riverBank

            flowingRiver

            if riverClean {
                cleanRiverLife
            } else {
                floatingTrash(
                    areaWidth: width
                )
            }

            trashBin
        }
        .frame(maxWidth: .infinity)
        .frame(height: 430)
        .clipShape(
            RoundedRectangle(cornerRadius: 30)
        )
        .onAppear {
            startRiverAnimation()
        }
    }

    // MARK: - River Bank

    private var riverBank: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.68, green: 0.88, blue: 0.54),
                    Color(red: 0.32, green: 0.66, blue: 0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                grassRow(reverseDirection: false)

                Spacer()

                grassRow(reverseDirection: true)
            }
            .padding(.vertical, 12)
        }
    }

    private func grassRow(
        reverseDirection: Bool
    ) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<24, id: \.self) { index in
                Capsule()
                    .fill(
                        index.isMultiple(of: 2)
                        ? Color.green
                        : Color.green.opacity(0.72)
                    )
                    .frame(
                        width: 4,
                        height: CGFloat(
                            14 + (index % 4) * 4
                        )
                    )
                    .rotationEffect(
                        .degrees(
                            reverseDirection
                            ? (index.isMultiple(of: 2) ? 7 : -7)
                            : (index.isMultiple(of: 2) ? -7 : 7)
                        ),
                        anchor: .bottom
                    )
            }
        }
    }

    // MARK: - Flowing Water

    private var flowingRiver: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38)
                .fill(
                    LinearGradient(
                        colors: riverClean
                        ? [
                            Color(red: 0.18, green: 0.76, blue: 0.91),
                            Color(red: 0.22, green: 0.65, blue: 0.88)
                        ]
                        : [
                            Color(red: 0.38, green: 0.58, blue: 0.63),
                            Color(red: 0.31, green: 0.48, blue: 0.53)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 250)
                .animation(
                    .easeInOut(duration: 0.8),
                    value: riverClean
                )

            ForEach(0..<6, id: \.self) { index in
                Capsule()
                    .fill(.white.opacity(0.30))
                    .frame(
                        width: CGFloat(65 + index * 13),
                        height: 5
                    )
                    .offset(
                        x: waterFlowOffset + CGFloat(index * 68),
                        y: CGFloat(-84 + index * 34)
                    )
            }

            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(.cyan.opacity(0.25))
                    .frame(
                        width: CGFloat(85 + index * 10),
                        height: 4
                    )
                    .offset(
                        x: -waterFlowOffset - CGFloat(index * 65),
                        y: CGFloat(-58 + index * 38)
                    )
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Floating Trash

    private func floatingTrash(
        areaWidth: CGFloat
    ) -> some View {
        ZStack {
            trashItem(
                symbol: "takeoutbag.and.cup.and.straw.fill",
                size: 53
            )
            .offset(
                x: -50,
                y: trashFloating ? -12 : 3
            )

            trashItem(
                symbol: "waterbottle.fill",
                size: 43
            )
            .rotationEffect(.degrees(-22))
            .offset(
                x: 72,
                y: trashFloating ? 40 : 52
            )

            trashItem(
                symbol: "shippingbox.fill",
                size: 38
            )
            .rotationEffect(.degrees(12))
            .offset(
                x: 5,
                y: trashFloating ? 75 : 64
            )
        }
        .frame(width: 180, height: 180)
        .offset(trashOffset)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    trashOffset = value.translation
                }
                .onEnded { value in
                    let requiredX = areaWidth * 0.22
                    let requiredY: CGFloat = 95

                    let reachedBin =
                        value.translation.width > requiredX &&
                        value.translation.height > requiredY

                    if reachedBin {
                        disposeTrash()
                    } else {
                        resetTrash()
                    }
                }
        )
        .accessibilityLabel(
            "Floating trash in the river"
        )
        .accessibilityHint(
            "Drag the trash down and right into the bin"
        )
    }

    private func trashItem(
        symbol: String,
        size: CGFloat
    ) -> some View {
        Image(systemName: symbol)
            .font(.system(size: size))
            .foregroundStyle(.white)
            .shadow(
                color: .black.opacity(0.16),
                radius: 4,
                y: 3
            )
    }

    // MARK: - Trash Bin

    private var trashBin: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color(
                                    red: 0.78,
                                    green: 0.86,
                                    blue: 0.86
                                )
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(
                        width: 88,
                        height: 105
                    )
                    .shadow(
                        color: .black.opacity(0.16),
                        radius: 7,
                        y: 5
                    )

                Image(systemName: "trash.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(
                        Color(
                            red: 0.14,
                            green: 0.58,
                            blue: 0.39
                        )
                    )

                Capsule()
                    .fill(
                        Color(
                            red: 0.20,
                            green: 0.62,
                            blue: 0.43
                        )
                    )
                    .frame(
                        width: 72,
                        height: 12
                    )
                    .offset(y: -51)
            }

            Text("BIN")
                .font(
                    .system(
                        size: 12,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)
        }
        .offset(x: 112, y: 132)
        .opacity(riverClean ? 0.70 : 1)
        .accessibilityLabel("Trash bin")
    }

    // MARK: - Clean River

    private var cleanRiverLife: some View {
        ZStack {
            if reduceMotion {
                SwimmingFishView(
                    color: .orange,
                    size: 62,
                    direction: .right,
                    speed: 0,
                    verticalPosition: -35,
                    waveHeight: 0,
                    startingProgress: 0.30
                )

                SwimmingFishView(
                    color: .yellow,
                    size: 52,
                    direction: .left,
                    speed: 0,
                    verticalPosition: 38,
                    waveHeight: 0,
                    startingProgress: 0.65
                )
            } else {
                SwimmingFishView(
                    color: .orange,
                    size: 62,
                    direction: .right,
                    speed: 0.085,
                    verticalPosition: -35,
                    waveHeight: 16,
                    startingProgress: 0.05
                )

                SwimmingFishView(
                    color: .yellow,
                    size: 52,
                    direction: .left,
                    speed: 0.065,
                    verticalPosition: 40,
                    waveHeight: 13,
                    startingProgress: 0.55
                )

                SwimmingFishView(
                    color: .pink,
                    size: 38,
                    direction: .right,
                    speed: 0.055,
                    verticalPosition: 82,
                    waveHeight: 9,
                    startingProgress: 0.35
                )
            }

            HStack(spacing: 130) {
                Image(systemName: "leaf.fill")
                Image(systemName: "leaf.fill")
            }
            .font(.system(size: 30))
            .foregroundStyle(.green)
            .offset(y: 84)

            Image(systemName: "sparkles")
                .font(.system(size: 31))
                .foregroundStyle(.yellow)
                .offset(x: 90, y: -82)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .clipped()
        .transition(
            .scale.combined(with: .opacity)
        )
    }

    // MARK: - Bottom Control

    @ViewBuilder
    private var bottomControl: some View {
        if showContinue {
            PrimaryButton(
                title: "Continue the Journey",
                action: onComplete
            )
            .transition(
                .move(edge: .bottom)
                .combined(with: .opacity)
            )
        } else {
            HStack(spacing: 8) {
                Image(systemName: "hand.draw.fill")

                Text("Drag the trash into the bin")
            }
            .font(
                .system(
                    size: 14,
                    weight: .semibold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 44)
            .background(.black.opacity(0.20))
            .clipShape(Capsule())
        }
    }

    // MARK: - River Animation

    private func startRiverAnimation() {
        guard !reduceMotion else {
            return
        }

        waterFlowOffset = -150
        trashFloating = false

        withAnimation(
            .linear(duration: 4.5)
            .repeatForever(autoreverses: false)
        ) {
            waterFlowOffset = 150
        }

        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            trashFloating = true
        }
    }

    // MARK: - Actions

    private func disposeTrash() {
        withAnimation(
            .easeInOut(duration: 0.45)
        ) {
            trashOffset = CGSize(
                width: 115,
                height: 135
            )
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.45
        ) {
            withAnimation(
                .easeInOut(duration: 0.75)
            ) {
                riverClean = true
                trashOffset = .zero
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.15
        ) {
            withAnimation(.spring()) {
                showContinue = true
            }
        }
    }

    private func resetTrash() {
        withAnimation(.spring()) {
            trashOffset = .zero
        }
    }
}

// MARK: - Swimming Fish

struct SwimmingFishView: View {

    enum SwimmingDirection {
        case left
        case right
    }

    let color: Color
    let size: CGFloat
    let direction: SwimmingDirection
    let speed: Double
    let verticalPosition: CGFloat
    let waveHeight: CGFloat
    let startingProgress: Double

    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                let time =
                    timeline.date.timeIntervalSinceReferenceDate

                let progress = normalizedProgress(
                    time: time
                )

                let travelWidth =
                    geometry.size.width + size * 1.7

                let xPosition =
                    horizontalPosition(
                        progress: progress,
                        travelWidth: travelWidth
                    )

                let waveAngle =
                    progress * .pi * 4

                let yPosition =
                    geometry.size.height / 2
                    + verticalPosition
                    + sin(waveAngle) * waveHeight

                let swimmingAngle =
                    cos(waveAngle) * 6

                let tailAngle =
                    sin(time * 11) * 24

                fishBody(
                    tailAngle: tailAngle
                )
                .frame(
                    width: size,
                    height: size * 0.65
                )
                .scaleEffect(
                    x: direction == .right ? 1 : -1,
                    y: 1
                )
                .rotationEffect(
                    .degrees(swimmingAngle)
                )
                .position(
                    x: xPosition,
                    y: yPosition
                )
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func normalizedProgress(
        time: TimeInterval
    ) -> Double {
        guard speed > 0 else {
            return startingProgress
        }

        let rawProgress =
            time * speed + startingProgress

        return rawProgress
            .truncatingRemainder(dividingBy: 1)
    }

    private func horizontalPosition(
        progress: Double,
        travelWidth: CGFloat
    ) -> CGFloat {
        let start = -size
        let end = travelWidth

        if direction == .right {
            return start + CGFloat(progress) * (end - start)
        }

        return end - CGFloat(progress) * (end - start)
    }

    private func fishBody(
        tailAngle: Double
    ) -> some View {
        ZStack {
            FishTailShape()
                .fill(color.opacity(0.88))
                .frame(
                    width: size * 0.38,
                    height: size * 0.42
                )
                .rotationEffect(
                    .degrees(tailAngle),
                    anchor: .trailing
                )
                .offset(x: -size * 0.47)

            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.92),
                            color,
                            color.opacity(0.72)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: size * 0.78,
                    height: size * 0.48
                )

            FishFinShape()
                .fill(color.opacity(0.65))
                .frame(
                    width: size * 0.31,
                    height: size * 0.20
                )
                .rotationEffect(.degrees(14))
                .offset(
                    x: -size * 0.04,
                    y: size * 0.15
                )

            Circle()
                .fill(.white)
                .frame(
                    width: size * 0.10,
                    height: size * 0.10
                )
                .offset(
                    x: size * 0.25,
                    y: -size * 0.06
                )

            Circle()
                .fill(.black)
                .frame(
                    width: size * 0.05,
                    height: size * 0.05
                )
                .offset(
                    x: size * 0.27,
                    y: -size * 0.06
                )

            Capsule()
                .fill(.white.opacity(0.28))
                .frame(
                    width: size * 0.25,
                    height: size * 0.035
                )
                .offset(
                    x: -size * 0.08,
                    y: -size * 0.10
                )
        }
    }
}

// MARK: - Fish Tail

struct FishTailShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.maxX,
                y: rect.midY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            ),
            control1: CGPoint(
                x: rect.width * 0.55,
                y: rect.height * 0.35
            ),
            control2: CGPoint(
                x: rect.width * 0.18,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            ),
            control: CGPoint(
                x: rect.width * 0.28,
                y: rect.midY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.midY
            ),
            control1: CGPoint(
                x: rect.width * 0.18,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.width * 0.55,
                y: rect.height * 0.65
            )
        )

        path.closeSubpath()

        return path
    }
}

// MARK: - Fish Fin

struct FishFinShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        )

        return path
    }
}
// MARK: - Generator Village Scene

struct LanternSceneView: View {

    let onComplete: () -> Void

    @State private var generatorRunning = false
    @State private var switchPressed = false
    @State private var electricityMoving = false
    @State private var villageLit = false
    @State private var showContinue = false
    @State private var generatorShake = false

    var body: some View {
        SceneBackground(
            colors: villageLit
            ? [
                Color(red: 0.11, green: 0.19, blue: 0.37),
                Color(red: 0.30, green: 0.28, blue: 0.50)
            ]
            : [
                Color.black,
                Color(red: 0.10, green: 0.05, blue: 0.17)
            ]
        ) {
            VStack(spacing: 12) {
                customHeader

                villageScene

                bottomControl
            }
        }
        .transition(.opacity)
    }

    // MARK: - Header

    private var customHeader: some View {
        VStack(spacing: 7) {
            HStack {
                Text("Choice 4 of 4")
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.white.opacity(0.78))

                Spacer()
            }

            Text(
                villageLit
                ? "The Village Has Power"
                : "A Village Without Power"
            )
            .font(
                .system(
                    size: 25,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.72)

            Text(
                villageLit
                ? "The generator brought light to every home."
                : "Press and hold the generator switch."
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(.white.opacity(0.82))
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Village Scene

    private var villageScene: some View {
        GeometryReader { geometry in
            ZStack {
                nightSky
                    .zIndex(0)

                distantHills
                    .zIndex(1)

                powerLines
                    .zIndex(2)

                villageHouses
                    .zIndex(3)

                generator
                    .zIndex(5)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 490)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Sky

    private var nightSky: some View {
        ZStack {
            LinearGradient(
                colors: villageLit
                ? [
                    Color(red: 0.12, green: 0.20, blue: 0.40),
                    Color(red: 0.28, green: 0.25, blue: 0.47)
                ]
                : [
                    Color(red: 0.02, green: 0.03, blue: 0.08),
                    Color(red: 0.09, green: 0.04, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(0..<18, id: \.self) { index in
                Circle()
                    .fill(
                        .white.opacity(
                            villageLit ? 0.72 : 0.42
                        )
                    )
                    .frame(
                        width: index.isMultiple(of: 3) ? 4 : 2,
                        height: index.isMultiple(of: 3) ? 4 : 2
                    )
                    .offset(
                        x: CGFloat((index % 6) * 53 - 132),
                        y: CGFloat((index / 6) * 44 - 175)
                    )
            }
        }
    }

    // MARK: - Hills

    private var distantHills: some View {
        ZStack(alignment: .bottom) {
            Ellipse()
                .fill(
                    villageLit
                    ? Color.green.opacity(0.30)
                    : Color.black.opacity(0.72)
                )
                .frame(width: 420, height: 180)
                .offset(x: -90, y: 110)

            Ellipse()
                .fill(
                    villageLit
                    ? Color.green.opacity(0.23)
                    : Color.black.opacity(0.58)
                )
                .frame(width: 420, height: 170)
                .offset(x: 125, y: 120)
        }
    }

    // MARK: - Power Lines

    private var powerLines: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            let firstPoleX = width * 0.18
            let secondPoleX = width * 0.50
            let thirdPoleX = width * 0.82
            let poleTopY: CGFloat = 170

            ZStack {
                pole(
                    at: firstPoleX,
                    topY: poleTopY
                )

                pole(
                    at: secondPoleX,
                    topY: poleTopY
                )

                pole(
                    at: thirdPoleX,
                    topY: poleTopY
                )

                Path { path in
                    path.move(
                        to: CGPoint(
                            x: firstPoleX,
                            y: poleTopY
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: secondPoleX,
                            y: poleTopY
                        ),
                        control: CGPoint(
                            x: (firstPoleX + secondPoleX) / 2,
                            y: poleTopY + 22
                        )
                    )

                    path.move(
                        to: CGPoint(
                            x: secondPoleX,
                            y: poleTopY
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: thirdPoleX,
                            y: poleTopY
                        ),
                        control: CGPoint(
                            x: (secondPoleX + thirdPoleX) / 2,
                            y: poleTopY + 22
                        )
                    )
                }
                .stroke(
                    villageLit
                    ? Color.yellow.opacity(0.82)
                    : Color.white.opacity(0.36),
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )

                if electricityMoving {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 21))
                        .foregroundStyle(.yellow)
                        .position(
                            x: electricityMoving
                            ? thirdPoleX
                            : firstPoleX,
                            y: poleTopY - 14
                        )
                        .animation(
                            .linear(duration: 1.4),
                            value: electricityMoving
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func pole(
        at xPosition: CGFloat,
        topY: CGFloat
    ) -> some View {
        ZStack {
            Capsule()
                .fill(
                    Color(red: 0.58, green: 0.39, blue: 0.25)
                )
                .frame(width: 10, height: 125)
                .position(
                    x: xPosition,
                    y: topY + 62
                )

            Capsule()
                .fill(
                    Color(red: 0.58, green: 0.39, blue: 0.25)
                )
                .frame(width: 56, height: 8)
                .position(
                    x: xPosition,
                    y: topY
                )

            Circle()
                .fill(.gray.opacity(0.90))
                .frame(width: 10, height: 10)
                .position(
                    x: xPosition - 20,
                    y: topY
                )

            Circle()
                .fill(.gray.opacity(0.90))
                .frame(width: 10, height: 10)
                .position(
                    x: xPosition + 20,
                    y: topY
                )
        }
    }

    // MARK: - Houses

    private var villageHouses: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VillageHouse(
                houseColor: Color(
                    red: 0.36,
                    green: 0.42,
                    blue: 0.50
                ),
                lightsOn: villageLit,
                delay: 0.0
            )

            VillageHouse(
                houseColor: Color(
                    red: 0.40,
                    green: 0.34,
                    blue: 0.48
                ),
                lightsOn: villageLit,
                delay: 0.18
            )

            VillageHouse(
                houseColor: Color(
                    red: 0.32,
                    green: 0.44,
                    blue: 0.42
                ),
                lightsOn: villageLit,
                delay: 0.36
            )
        }
        .position(x: 185, y: 375)
    }

    // MARK: - Generator

    private var generator: some View {
        VStack(spacing: 2) {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0.95,
                                    green: 0.38,
                                    blue: 0.12
                                ),
                                Color(
                                    red: 0.63,
                                    green: 0.16,
                                    blue: 0.07
                                )
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 104, height: 82)
                    .shadow(
                        color: .black.opacity(0.28),
                        radius: 7,
                        y: 5
                    )

                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(
                                generatorRunning
                                ? Color.green
                                : Color.red
                            )
                            .frame(width: 10, height: 10)

                        Text(
                            generatorRunning
                            ? "RUNNING"
                            : "POWER"
                        )
                        .font(
                            .system(
                                size: 8,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.white)

                        Spacer()
                    }

                    HStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(.black.opacity(0.24))
                                .frame(width: 32, height: 32)

                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.gray.opacity(0.95))
                                .rotationEffect(
                                    .degrees(
                                        generatorRunning ? 360 : 0
                                    )
                                )
                                .animation(
                                    generatorRunning
                                    ? .linear(duration: 0.8)
                                        .repeatForever(
                                            autoreverses: false
                                        )
                                    : .default,
                                    value: generatorRunning
                                )
                        }

                        generatorSwitch
                    }
                }
                .padding(.horizontal, 10)
                .frame(width: 104, height: 82)
            }

            HStack(spacing: 44) {
                Circle()
                    .fill(.black)
                    .frame(width: 20, height: 20)

                Circle()
                    .fill(.black)
                    .frame(width: 20, height: 20)
            }
            .offset(y: -12)
        }
        .position(x: 185, y: 420)
        .offset(x: generatorShake ? -2 : 2)
        .animation(
            generatorRunning
            ? .linear(duration: 0.10)
                .repeatForever(autoreverses: true)
            : .default,
            value: generatorShake
        )
        .accessibilityLabel("Electric generator")
    }

    // MARK: - Generator Switch

    private var generatorSwitch: some View {
        VStack(spacing: 2) {
            Text("START")
                .font(
                    .system(
                        size: 7,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white.opacity(0.92))

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.black.opacity(0.38))
                    .frame(width: 34, height: 46)

                Capsule()
                    .fill(
                        switchPressed
                        ? Color.green
                        : Color.gray
                    )
                    .frame(width: 20, height: 32)

                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                    .offset(
                        y: switchPressed ? -6 : 6
                    )
            }
        }
        .frame(width: 42, height: 56)
        .contentShape(Rectangle())
        .onLongPressGesture(minimumDuration: 1.0) {
            startGenerator()
        }
        .accessibilityLabel("Generator start switch")
        .accessibilityHint(
            "Press and hold to start the generator"
        )
    }

    // MARK: - Bottom Control

    @ViewBuilder
    private var bottomControl: some View {
        if showContinue {
            Button(action: onComplete) {
                HStack(spacing: 9) {
                    Text("See the Result")

                    Image(systemName: "arrow.right")
                }
                .font(
                    .system(
                        size: 16,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.indigo)
                .padding(.horizontal, 24)
                .frame(height: 50)
                .background(.white)
                .clipShape(Capsule())
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 7,
                    y: 4
                )
            }
            .transition(
                .move(edge: .bottom)
                .combined(with: .opacity)
            )
        } else {
            HStack(spacing: 8) {
                Image(
                    systemName: generatorRunning
                    ? "bolt.fill"
                    : "hand.tap.fill"
                )

                Text(
                    generatorRunning
                    ? "Power is reaching the village"
                    : "Press and hold the START switch"
                )
            }
            .font(
                .system(
                    size: 14,
                    weight: .semibold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 44)
            .background(.black.opacity(0.24))
            .clipShape(Capsule())
        }
    }

    // MARK: - Action

    private func startGenerator() {
        guard !generatorRunning else { return }

        withAnimation(
            .spring(
                response: 0.4,
                dampingFraction: 0.65
            )
        ) {
            switchPressed = true
            generatorRunning = true
            generatorShake = true
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.45
        ) {
            electricityMoving = false

            withAnimation(.linear(duration: 1.4)) {
                electricityMoving = true
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.35
        ) {
            withAnimation(.easeInOut(duration: 1.0)) {
                villageLit = true
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.1
        ) {
            withAnimation(.spring()) {
                showContinue = true
            }
        }
    }
}

// MARK: - Village House

struct VillageHouse: View {

    let houseColor: Color
    let lightsOn: Bool
    let delay: Double

    @State private var visibleLight = false

    var body: some View {
        VStack(spacing: 0) {
            TriangleRoof()
                .fill(
                    Color(
                        red: 0.34,
                        green: 0.18,
                        blue: 0.14
                    )
                )
                .frame(width: 72, height: 41)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(houseColor)
                    .frame(width: 63, height: 59)

                HStack(spacing: 8) {
                    window
                    window
                }
                .offset(y: -8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(.brown)
                    .frame(width: 16, height: 27)
                    .offset(y: 16)
            }
        }
        .onAppear {
            if lightsOn {
                scheduleLight()
            }
        }
        .onChange(of: lightsOn) { _, newValue in
            if newValue {
                scheduleLight()
            } else {
                visibleLight = false
            }
        }
    }

    private var window: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                visibleLight
                ? Color.yellow
                : Color.black.opacity(0.65)
            )
            .frame(width: 15, height: 20)
            .shadow(
                color: visibleLight
                ? Color.yellow.opacity(0.72)
                : .clear,
                radius: 8
            )
    }

    private func scheduleLight() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay
        ) {
            withAnimation(.easeInOut(duration: 0.45)) {
                visibleLight = true
            }
        }
    }
}

// MARK: - Roof Shape

struct TriangleRoof: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )

        path.closeSubpath()

        return path
    }
}
// MARK: - Ending

struct EndingView: View {

    let onRestart: () -> Void

    @State private var contentVisible = false

    var body: some View {
        SceneBackground(
            colors: [
                Color.orange.opacity(0.82),
                Color.blue.opacity(0.82)
            ]
        ) {
            VStack(spacing: 27) {
                Spacer()

                HStack(spacing: 21) {
                    Image(systemName: "camera.macro")
                    Image(systemName: "bird.fill")
                    Image(systemName: "fish.fill")
                    Image(systemName: "lightbulb.max.fill")
                }
                .font(.system(size: 40))
                .foregroundStyle(.yellow)
                .scaleEffect(contentVisible ? 1 : 0.25)
                .opacity(contentVisible ? 1 : 0)

                Text("Every Choice Matters")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text("Small choices can create meaningful change.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(
                    "The world became brighter because you chose to care."
                )
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.82))

                Spacer()

                PrimaryButton(
                    title: "Experience Again",
                    action: onRestart
                )
            }
            .onAppear {
                withAnimation(.spring(response: 0.8).delay(0.2)) {
                    contentVisible = true
                }
            }
        }
    }
}

// MARK: - Shared Layout

struct SceneBackground<Content: View>: View {

    let colors: [Color]
    let content: Content

    init(
        colors: [Color],
        @ViewBuilder content: () -> Content
    ) {
        self.colors = colors
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            content
                .padding(.horizontal, 22)
                .padding(.top, 12)
                .padding(.bottom, 18)
        }
    }
}

struct StoryHeader: View {

    let progress: String
    let title: String
    let instruction: String

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(progress)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.82))

                Spacer()
            }

            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(instruction)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)
        }
        .padding(17)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 23))
    }
}

struct PrimaryButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)

                Spacer()

                Image(systemName: "arrow.right")
            }
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.indigo)
            .padding(.horizontal, 21)
            .frame(height: 57)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .accessibilityLabel(title)
    }
}

#Preview {
    ContentView()
}
