# Tuyu iOS

> 「图语」iOS 客户端 - SwiftUI + Swift Package Manager

## 技术栈

- SwiftUI（iOS 16+）
- Swift Package Manager
- MVVM 架构
- NavigationStack + 三 Tab 独立路由

## 工程结构

```
ios/
├── Package.swift           # SPM 工程定义
├── Sources/Tuyu/
│   ├── App/                # 应用入口、根视图、路由
│   ├── Models/             # 数据模型 (Template/Category/Work)
│   ├── DesignSystem/       # Token (颜色/字体/间距/圆角/阴影)
│   ├── Components/         # 基础组件 & 业务组件
│   │   ├── Base/           # TuyuButton / TuyuCard / TuyuTopBar / TuyuModal / TuyuLoader
│   │   └── Business/       # TuyuCategoryTabs / TuyuStepBar / TuyuTemplateCard / TuyuBanner / TuyuWorkCard / TuyuUploadArea
│   ├── Views/              # 页面
│   │   ├── Home/           # 首页（分类 + 模板网格）
│   │   ├── TemplateDetail/ # 模板详情
│   │   ├── Upload/         # 上传
│   │   ├── Generating/     # 生成中
│   │   ├── Result/         # 结果页
│   │   ├── Works/          # 作品列表 / 作品详情
│   │   └── Me/             # 我的 / 设置 / 关于 / 隐私政策
│   ├── Services/           # TemplateData (本地) / APIClient (远端)
│   └── Utils/              # Color+Hex / Extensions / ImageLoader
└── Tests/TuyuTests/        # 单元测试
```

## 路由

`AppState` 维护三个 Tab 独立的 `NavigationPath`：

- `homePath` → `HomeDestination` (templateDetail / upload / generating / result)
- `worksPath` → `WorksDestination` (workDetail)
- `mePath` → `MeDestination` (settings / about / privacy)

跨 Tab 跳转用 `appState.navigateHome / Works / Me(_:)` 快捷方法。

## 构建

需要 Xcode 15.0+ 和 iOS 16+ Simulator。

```bash
# 编译
make build

# 测试
make test

# 用 Xcode 打开
make open
```

或直接：

```bash
xcodebuild \
  -scheme Tuyu \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -derivedDataPath build \
  build
```

## CI

`.github/workflows/ios.yml` 在 push / PR 时跑 macOS-14 + Xcode 15.4，自动 build + test。
