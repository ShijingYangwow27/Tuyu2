import SwiftUI

@main
struct TuyuApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
        }
    }
}

final class AppState: ObservableObject {
    @Published var currentTab: Tab = .home

    // 每个 Tab 独立的导航栈
    @Published var homePath = NavigationPath()
    @Published var worksPath = NavigationPath()
    @Published var mePath = NavigationPath()

    enum Tab: String, CaseIterable, Hashable {
        case home, works, me

        var title: String {
            switch self {
            case .home: return "首页"
            case .works: return "作品"
            case .me: return "我的"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .works: return "photo.on.rectangle"
            case .me: return "person.fill"
            }
        }
    }

    // MARK: - 导航快捷方法
    func navigateHome(_ destination: HomeDestination) {
        currentTab = .home
        homePath.append(destination)
    }

    func navigateWorks(_ destination: WorksDestination) {
        currentTab = .works
        worksPath.append(destination)
    }

    func navigateMe(_ destination: MeDestination) {
        currentTab = .me
        mePath.append(destination)
    }

    func popHomeToRoot() { homePath = NavigationPath() }
    func popWorksToRoot() { worksPath = NavigationPath() }
    func popMeToRoot() { mePath = NavigationPath() }
}

// MARK: - 各 Tab 独立目的地

enum HomeDestination: Hashable {
    case templateDetail(Template)
    case upload(Template)
    case generating(taskId: String, template: Template)
    case result(Work)
}

enum WorksDestination: Hashable {
    case workDetail(Work)
}

enum MeDestination: Hashable {
    case settings
    case about
    case privacy
}

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.currentTab) {
            // 首页 Tab
            NavigationStack(path: $appState.homePath) {
                HomeView()
                    .navigationDestination(for: HomeDestination.self) { dest in
                        homeDestinationView(dest)
                    }
            }
            .tag(AppState.Tab.home)
            .tabItem {
                Image(systemName: AppState.Tab.home.icon)
                Text(AppState.Tab.home.title)
            }

            // 作品 Tab
            NavigationStack(path: $appState.worksPath) {
                WorksView()
                    .navigationDestination(for: WorksDestination.self) { dest in
                        worksDestinationView(dest)
                    }
            }
            .tag(AppState.Tab.works)
            .tabItem {
                Image(systemName: AppState.Tab.works.icon)
                Text(AppState.Tab.works.title)
            }

            // 我的 Tab
            NavigationStack(path: $appState.mePath) {
                MeView()
                    .navigationDestination(for: MeDestination.self) { dest in
                        meDestinationView(dest)
                    }
            }
            .tag(AppState.Tab.me)
            .tabItem {
                Image(systemName: AppState.Tab.me.icon)
                Text(AppState.Tab.me.title)
            }
        }
        .tint(TuyuColors.accent)
    }

    // MARK: - 路由表

    @ViewBuilder
    private func homeDestinationView(_ destination: HomeDestination) -> some View {
        switch destination {
        case .templateDetail(let template):
            TemplateDetailView(template: template)
        case .upload(let template):
            UploadView(template: template)
        case .generating(let taskId, let template):
            GeneratingView(taskId: taskId, template: template)
        case .result(let work):
            ResultView(work: work)
        }
    }

    @ViewBuilder
    private func worksDestinationView(_ destination: WorksDestination) -> some View {
        switch destination {
        case .workDetail(let work):
            WorkDetailView(work: work)
        }
    }

    @ViewBuilder
    private func meDestinationView(_ destination: MeDestination) -> some View {
        switch destination {
        case .settings:
            SettingsView()
        case .about:
            AboutView()
        case .privacy:
            PrivacyView()
        }
    }
}
