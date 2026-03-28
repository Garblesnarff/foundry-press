import SwiftUI
import PDFKit

/// PDF preview pane using PDFKit
///
/// Features:
/// - Display compiled PDF output
/// - Zoom in/out controls
/// - Pan and scroll
/// - Export to file
struct PreviewPane: View {
    @State private var pdfView: PDFView?
    @State private var zoomLevel: CGFloat = 1.0

    let pdfData: Data?
    let isLoading: Bool
    let error: String?

    var body: some View {
        ZStack {
            if let error = error {
                errorView(error)
            } else if isLoading {
                loadingView
            } else if let pdfData = pdfData {
                pdfPreview(pdfData)
            } else {
                emptyView
            }
        }
        .background(DesignSystem.Colors.bgBase)
    }

    // MARK: - State Views

    private var loadingView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(DesignSystem.Colors.accentAmber)

            Text(ForgeLanguage.forging)
                .font(DesignSystem.Typography.uiFont(size: 14))
                .foregroundColor(DesignSystem.Colors.accentAmber)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.textMuted)

            Text(ForgeLanguage.noPreview)
                .font(DesignSystem.Typography.uiFont(size: 18, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Text(ForgeLanguage.startTyping)
                .font(DesignSystem.Typography.uiFont(size: 14))
                .foregroundColor(DesignSystem.Colors.textMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.danger)

            Text(ForgeLanguage.compilationError)
                .font(DesignSystem.Typography.uiFont(size: 18, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text(error)
                .font(DesignSystem.Typography.codeFont(size: 12))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.lg)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - PDF Preview

    @ViewBuilder
    private func pdfPreview(_ data: Data) -> some View {
        ZStack {
            PDFViewRepresentable(data: data, zoomLevel: $zoomLevel, pdfView: $pdfView)
                .background(DesignSystem.Colors.bgBase)

            // Zoom controls overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .frame(width: 32, height: 32)
                                .background(DesignSystem.Colors.bgElevated)
                                .cornerRadius(DesignSystem.Radii.small)
                        }
                        .buttonStyle(.plain)
                        .help("Zoom In")

                        Button(action: zoomOut) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .frame(width: 32, height: 32)
                                .background(DesignSystem.Colors.bgElevated)
                                .cornerRadius(DesignSystem.Radii.small)
                        }
                        .buttonStyle(.plain)
                        .help("Zoom Out")

                        Divider()
                            .frame(width: 24)
                            .background(DesignSystem.Colors.borderDefault)

                        Button(action: fitToWidth) {
                            Image(systemName: "arrow.left.and.right")
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .frame(width: 32, height: 32)
                                .background(DesignSystem.Colors.bgElevated)
                                .cornerRadius(DesignSystem.Radii.small)
                        }
                        .buttonStyle(.plain)
                        .help("Fit to Width")

                        Button(action: fitToPage) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .frame(width: 32, height: 32)
                                .background(DesignSystem.Colors.bgElevated)
                                .cornerRadius(DesignSystem.Radii.small)
                        }
                        .buttonStyle(.plain)
                        .help("Fit to Page")
                    }
                    .padding(DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.bgSurface.opacity(0.9))
                    .cornerRadius(DesignSystem.Radii.medium)
                }
                .padding(DesignSystem.Spacing.md)
            }
        }
    }

    // MARK: - Actions

    private func zoomIn() {
        zoomLevel += 0.25
        pdfView?.zoomIn(nil)
    }

    private func zoomOut() {
        zoomLevel = max(0.5, zoomLevel - 0.25)
        pdfView?.zoomOut(nil)
    }

    private func fitToWidth() {
        guard let pdfView = pdfView else { return }
        if let page = pdfView.document?.page(at: 0) {
            let pageRect = page.bounds(for: .mediaBox)
            let scaleFactor = pdfView.bounds.width / pageRect.width
            pdfView.scaleFactor = scaleFactor
            zoomLevel = scaleFactor
        }
    }

    private func fitToPage() {
        pdfView?.autoScales = true
    }
}

// MARK: - PDF View Representable

struct PDFViewRepresentable: NSViewRepresentable {
    let data: Data
    @Binding var zoomLevel: CGFloat
    @Binding var pdfView: PDFView?

    func makeNSView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument(data: data)
        view.autoScales = true
        view.backgroundColor = NSColor(DesignSystem.Colors.bgBase)
        pdfView = view
        return view
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        if nsView.document?.dataRepresentation() != data {
            nsView.document = PDFDocument(data: data)
            nsView.autoScales = true
        }
    }
}

#Preview {
    PreviewPane(pdfData: nil, isLoading: false, error: nil)
        .frame(width: 400, height: 600)
}
