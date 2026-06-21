PLATFORM ?= iOS Simulator,name=iPhone 15
SCHEME = Tuyu
DERIVED = build

.PHONY: help build test clean open resolve

help:
	@echo "Tuyu iOS 工程构建脚本"
	@echo ""
	@echo "  make build    编译 iOS 包"
	@echo "  make test     跑单元测试"
	@echo "  make open     用 Xcode 打开工程"
	@echo "  make clean    清理构建产物"
	@echo "  make resolve  刷新 SwiftPM 依赖"

build:
	xcodebuild \
		-scheme $(SCHEME) \
		-destination 'platform=$(PLATFORM)' \
		-derivedDataPath $(DERIVED) \
		build

test:
	xcodebuild \
		-scheme $(SCHEME) \
		-destination 'platform=$(PLATFORM)' \
		-derivedDataPath $(DERIVED) \
		test

open:
	open Package.swift

resolve:
	xcodebuild -resolvePackageDependencies -scheme $(SCHEME)

clean:
	rm -rf $(DERIVED) .build
	xcodebuild -scheme $(SCHEME) clean 2>/dev/null || true
