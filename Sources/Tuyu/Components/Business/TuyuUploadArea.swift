import SwiftUI
import PhotosUI

public struct TuyuUploadArea: View {
    @Binding public var image: UIImage?
    public let maxSizeMB: Int
    public let onError: ((String) -> Void)?

    @State private var isPickerPresented = false
    @State private var isUploading = false
    @State private var pickerItem: PhotosPickerItem?

    public init(image: Binding<UIImage?>, maxSizeMB: Int = 10, onError: ((String) -> Void)? = nil) {
        self._image = image
        self.maxSizeMB = maxSizeMB
        self.onError = onError
    }

    public var body: some View {
        VStack(spacing: TuyuSpacing.s4) {
            if image != nil {
                // 已选图片
                imagePreview(imageBinding: $image, pickerItemBinding: $pickerItem)
            } else {
                // 上传区
                uploadZone
            }
        }
    }

    private var uploadZone: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            VStack(spacing: TuyuSpacing.s3) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 48))
                    .foregroundColor(TuyuColors.muted)

                Text("点击选择图片")
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.fg)

                Text("支持 JPG/PNG，不超过 \(maxSizeMB)MB")
                    .font(TuyuTypography.sm)
                    .foregroundColor(TuyuColors.muted)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 240)
            .background(TuyuColors.bg)
            .overlay(
                RoundedRectangle(cornerRadius: TuyuRadius.lg)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
                    .foregroundColor(TuyuColors.border)
            )
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
        }
        .onChange(of: pickerItem) { newValue in
            handleSelection(newValue)
        }
    }

    private func imagePreview(imageBinding: Binding<UIImage?>, pickerItemBinding: Binding<PhotosPickerItem?>) -> some View {
        VStack(spacing: TuyuSpacing.s3) {
            if let image = imageBinding.wrappedValue {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 320)
                    .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
            }

            HStack(spacing: TuyuSpacing.s3) {
                TuyuButton(
                    type: .secondary,
                    size: .medium,
                    text: "重新选择"
                ) {
                    imageBinding.wrappedValue = nil
                    pickerItemBinding.wrappedValue = nil
                }

                TuyuButton(
                    type: .text,
                    size: .medium,
                    text: "删除"
                ) {
                    imageBinding.wrappedValue = nil
                    pickerItemBinding.wrappedValue = nil
                }
            }
        }
    }

    private func handleSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    let sizeMB = Double(data.count) / 1024.0 / 1024.0
                    if sizeMB > Double(maxSizeMB) {
                        await MainActor.run {
                            onError?("文件过大（\(String(format: "%.1f", sizeMB))MB），请选择 \(maxSizeMB)MB 以内的图片")
                        }
                        return
                    }

                    if let img = UIImage(data: data) {
                        await MainActor.run {
                            image = img
                        }
                    } else {
                        await MainActor.run {
                            onError?("无法解析图片")
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    onError?("图片加载失败：\(error.localizedDescription)")
                }
            }
        }
    }
}
