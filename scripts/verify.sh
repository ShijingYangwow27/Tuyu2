#!/usr/bin/env bash
# Tuyu iOS 工程的本地快速校验脚本
# 在没有 Xcode / iOS SDK 的环境下，只能做语法级检查
# 有 Xcode 的环境，请用 `make build` / `make test`

set -e
cd "$(dirname "$0")/.."

echo "=== 1. 校验所有 .swift 文件语法 ==="
find Sources -name "*.swift" | while read f; do
  if ! xcrun swiftc -parse -sdk "$(xcrun --show-sdk-path --sdk macosx)" -target arm64-apple-macosx26.0 "$f" 2>/dev/null; then
    echo "  [FAIL] $f"
    xcrun swiftc -parse -sdk "$(xcrun --show-sdk-path --sdk macosx)" -target arm64-apple-macosx26.0 "$f" 2>&1 | head -3
    exit 1
  fi
done
echo "  [OK] 所有 $(find Sources -name "*.swift" | wc -l | tr -d ' ') 个 Swift 文件语法通过"

echo ""
echo "=== 2. 校验纯数据/工具层类型 ==="
xcrun swiftc -typecheck \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -target arm64-apple-macosx26.0 \
  Sources/Tuyu/Models/Models.swift \
  Sources/Tuyu/DesignSystem/Tokens.swift \
  Sources/Tuyu/Utils/Color+Hex.swift \
  Sources/Tuyu/Services/TemplateData.swift \
  Sources/Tuyu/Services/APIClient.swift \
  2>&1 | grep -E "error:" && exit 1 || echo "  [OK] 数据/工具层类型检查通过"

echo ""
echo "=== 3. 单元测试源码语法 ==="
find Tests -name "*.swift" | while read f; do
  if ! xcrun swiftc -parse -sdk "$(xcrun --show-sdk-path --sdk macosx)" -target arm64-apple-macosx26.0 "$f" 2>/dev/null; then
    echo "  [FAIL] $f"
    exit 1
  fi
done
echo "  [OK] 单元测试语法通过"

echo ""
echo "=== 4. Package.swift 校验 ==="
swift package describe 2>/dev/null | head -5 || echo "  [WARN] swift package describe 不可用（需 iOS SDK）"

echo ""
echo "完成。完整 iOS 编译请在装有 Xcode 15+ 的机器上跑 'make build'。"
