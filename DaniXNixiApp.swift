import SwiftUI
import PhotosUI

@main
struct DaniXNixiApp: App {
    var body: some Scene {
        WindowGroup { SplashView() }
    }
}

struct SplashView: View {
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                MainView()
            } else {
                ZStack {
                    Color(red: 0.035, green: 0.055, blue: 0.10).ignoresSafeArea()
                    VStack(spacing: 10) {
                        Text("Dani × Nixi")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.cyan, .purple, .pink, .orange],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                        Text("VIDEO STAR ASSISTANT")
                            .font(.caption.weight(.medium))
                            .tracking(3)
                            .foregroundStyle(.white.opacity(0.55))
                    }
                }
                .task {
                    try? await Task.sleep(for: .seconds(3))
                    withAnimation(.easeInOut(duration: 0.3)) { showMain = true }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

enum AppPage { case home, donate }

struct MainView: View {
    @State private var page: AppPage = .home
    @State private var menuOpen = false
    @State private var buttonOffset = CGSize(width: 0, height: 0)
    @State private var menuOffset = CGSize(width: 0, height: 0)
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var status = "Chọn chức năng để bắt đầu."

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.035, green: 0.055, blue: 0.10),
                                    Color(red: 0.08, green: 0.10, blue: 0.22)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Text("Dani × Nixi")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Spacer()
                    Text("iOS")
                        .font(.caption.bold())
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(.white.opacity(0.10), in: Capsule())
                }

                HStack(spacing: 10) {
                    pageButton("house.fill", title: "Home", selected: page == .home) { page = .home }
                    pageButton("dollarsign.circle.fill", title: "Donate", selected: page == .donate) { page = .donate }
                }

                if page == .home {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("MAIN TOOLS").font(.caption.bold()).tracking(2).foregroundStyle(.white.opacity(0.55))
                        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 100,
                                     matching: .images, photoLibrary: .shared()) {
                            toolRow(icon: "photo.stack.fill", title: "Auto nhập ảnh",
                                    subtitle: "Chọn nhiều ảnh từ thư viện")
                        }
                        .onChange(of: selectedPhotos) { _, items in
                            status = items.isEmpty ? "Chưa chọn ảnh." : "Đã chọn \(items.count) ảnh. Bước nhập vào Video Star cần tích hợp riêng."
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Label("Auto chia beat", systemImage: "waveform")
                                .font(.headline).foregroundStyle(.white)
                            Text("Chọn cách xác định điểm chuyển ảnh")
                                .font(.subheadline).foregroundStyle(.white.opacity(0.6))
                            Button {
                                status = "Đã chọn: cắt tại cao trào. Bộ phân tích nhạc chưa được nối trong bản khung."
                            } label: {
                                HStack {
                                    Image(systemName: "bolt.fill").foregroundStyle(.orange)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("1. Cắt tại cao trào").foregroundStyle(.white)
                                        Text("Chuyển ảnh ở đoạn nhạc mạnh nhất").font(.caption).foregroundStyle(.white.opacity(0.55))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.4))
                                }.padding(13).background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
                            }
                            Button {
                                status = "Đã chọn: cắt trước cao trào. Bộ phân tích nhạc chưa được nối trong bản khung."
                            } label: {
                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis").foregroundStyle(.cyan)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("2. Cắt trước cao trào").foregroundStyle(.white)
                                        Text("Chuyển ảnh khi nhạc bắt đầu dâng lên").font(.caption).foregroundStyle(.white.opacity(0.55))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.4))
                                }.padding(13).background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(15)
                        .background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 52)).foregroundStyle(.yellow)
                        Text("Donate").font(.title.bold()).foregroundStyle(.white)
                        Text("Coming Soon").font(.headline).foregroundStyle(.white.opacity(0.55))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Text(status)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
                Spacer(minLength: 4)
            }
            .padding(18)

            // Floating launcher stays independent from the menu, so closing the menu never hides it.
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    rainbowLauncher
                        .offset(buttonOffset)
                        .gesture(DragGesture().onChanged { buttonOffset = $0.translation })
                        .padding(.trailing, 18)
                        .padding(.bottom, 24)
                }
            }
            .ignoresSafeArea(edges: .bottom)

            if menuOpen {
                floatingMenu
                    .offset(menuOffset)
                    .gesture(DragGesture().onChanged { menuOffset = $0.translation })
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(5)
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.82), value: menuOpen)
    }

    private var rainbowLauncher: some View {
        Button {
            menuOpen.toggle()
        } label: {
            Image(systemName: menuOpen ? "xmark" : "sparkles")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: Circle()
                )
                .overlay(Circle().stroke(.white.opacity(0.8), lineWidth: 2))
                .shadow(color: .purple.opacity(0.45), radius: 14, y: 5)
        }
        .buttonStyle(.plain)
    }

    private var floatingMenu: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("DANI × NIXI").font(.caption.bold()).tracking(1.5).foregroundStyle(.white.opacity(0.65))
                Spacer()
                Button { menuOpen = false } label: {
                    Image(systemName: "xmark.circle.fill").font(.title3).foregroundStyle(.white.opacity(0.75))
                }
            }
            Button { page = .home; menuOpen = false } label: {
                Label("Home", systemImage: "house.fill").foregroundStyle(.white)
            }
            Button { page = .donate; menuOpen = false } label: {
                Label("Donate", systemImage: "dollarsign.circle.fill").foregroundStyle(.white)
            }
            Text("Kéo phần menu để di chuyển").font(.caption2).foregroundStyle(.white.opacity(0.45))
        }
        .padding(16)
        .frame(width: 235)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.18), lineWidth: 1))
        .shadow(color: .black.opacity(0.35), radius: 24, y: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(.top, 100)
        .padding(.trailing, 18)
    }

    private func pageButton(_ icon: String, title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(selected ? .white : .white.opacity(0.65))
                .background(selected ? .purple.opacity(0.65) : .white.opacity(0.06), in: RoundedRectangle(cornerRadius: 13))
        }
    }

    private func toolRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.title2).foregroundStyle(.cyan)
                .frame(width: 44, height: 44).background(.cyan.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text(subtitle).font(.caption).foregroundStyle(.white.opacity(0.55))
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.4))
        }
        .padding(13)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
    }
}
