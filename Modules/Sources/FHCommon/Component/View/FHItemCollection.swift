//
//  FHItemCollection.swift
//
//
//  Created by Kostya Tsyvilko on 17.04.24.
//

import SwiftUI

public protocol FHCollectionItem: Identifiable {
    var title: String { get }
    var description: String? { get }
    var iconName: String { get }
    var isSelected: Bool { get set }
}

public struct FHItemCollection<Item: FHCollectionItem>: View {
    public enum PresentationType {
        case compact
        case full

        var columnsCount: Int {
            switch self {
            case .compact: 2
            case .full: 1
            }
        }
    }

    public struct Configuration {
        let presentationType: PresentationType
        let supportMultipleSelection: Bool
        let iconSize: CGFloat
        let cellColor: Color
        let cellSelectedColor: Color
        let cellCornerRadius: CGFloat
        let cellBorderColor: Color
        let cellSelectedBorderColor: Color
        let cellBorderWidth: CGFloat

        // TODO: add - allowMultipleSelection

        public init(
            presentationType: PresentationType = .compact,
            supportMultipleSelection: Bool = true,
            iconSize: CGFloat = 25,
            cellColor: Color = Colors.system,
            cellSelectedColor: Color = Colors.gray6,
            cellCornerRadius: CGFloat = 10,
            cellBorderColor: Color = Colors.lightGray,
            cellSelectedBorderColor: Color = .primary,
            cellBorderWidth: CGFloat = 1
        ) {
            self.presentationType = presentationType
            self.supportMultipleSelection = supportMultipleSelection
            self.iconSize = iconSize
            self.cellColor = cellColor
            self.cellSelectedColor = cellSelectedColor
            self.cellCornerRadius = cellCornerRadius
            self.cellBorderColor = cellBorderColor
            self.cellSelectedBorderColor = cellSelectedBorderColor
            self.cellBorderWidth = cellBorderWidth
        }
    }

    private var items: [Item]
    private let configuration: Configuration
    private let onChangeSelection: ((Item) -> Void)?
    private let columns: [GridItem]

    public init(
        items: [Item],
        configuration: Configuration = Configuration(),
        onChangeSelection: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.configuration = configuration
        self.onChangeSelection = onChangeSelection
        self.columns = (0..<configuration.presentationType.columnsCount)
            .map { _ in
                GridItem(.flexible(), spacing: Layout.Spacing.smallMedium)
            }
    }

    public var body: some View {
        ScrollView {
            content()
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder private func content() -> some View {
        LazyVGrid(columns: columns, spacing: Layout.Spacing.smallMedium) {
            ForEach(items) { item in
                switch configuration.presentationType {
                case .compact:
                    itemCell(
                        item,
                        content: compactItemCell(item)
                    )
                case .full:
                    itemCell(
                        item,
                        content: fullItemCell(item)
                    )
                }

            }
        }
    }
}

// MARK: - Item
private extension FHItemCollection {
    @ViewBuilder func compactItemCell(_ item: Item) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Layout.Spacing.small) {
                Image(systemName: item.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: configuration.iconSize)
                Text(item.title)
            }

            Spacer()
        }
    }

    @ViewBuilder func fullItemCell(_ item: Item) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Layout.Spacing.small) {
                Text(item.title)
                    .fontWeight(.semibold)

                if let description = item.description {
                    Text(description)
                }
            }

            Spacer()

            Image(systemName: item.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: configuration.iconSize)
        }
    }

    @ViewBuilder func itemCell<Content: View>(_ item: Item, content: Content) -> some View {
        content
            .padding(.horizontal, Layout.Spacing.smallMedium)
            .padding(.vertical, Layout.Spacing.medium)
            .background(item.isSelected ? configuration.cellSelectedColor : configuration.cellColor)
            .clipShape(
                RoundedRectangle(
                    cornerSize: CGSize(width: configuration.cellCornerRadius, height: configuration.cellCornerRadius)
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerSize: CGSize(width: configuration.cellCornerRadius, height: configuration.cellCornerRadius)
                )
                .stroke(item.isSelected ? configuration.cellSelectedBorderColor : configuration.cellBorderColor, lineWidth: configuration.cellBorderWidth)
            )
            .onTapGesture {
                onItemTapped(item)
            }
    }

    private func onItemTapped(_ item: Item) {
        let selectedItems = items.filter { $0.isSelected }
        if !configuration.supportMultipleSelection {
            selectedItems.forEach { onChangeSelection?($0) }
        }
        onChangeSelection?(item)
    }
}

#if DEBUG
    #Preview {
        struct Item: FHCollectionItem {
            let id = UUID()
            let title: String
            let description: String?
            let iconName: String
            var isSelected: Bool
        }
        @State var items = (0..<10).map { i in
            Item(title: "Test", description: "123", iconName: "person", isSelected: i % 2 == 0)
        }
        let configuration = FHItemCollection<Item>.Configuration(
            presentationType: .compact
        )
        return FHItemCollection(
            items: items,
            configuration: configuration
        )
    }
#endif
