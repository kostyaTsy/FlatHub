//
//  ChooseCountryView.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseCountryView: View {
    @Perception.Bindable private var store: StoreOf<ChooseCountryFeature>

    init(store: StoreOf<ChooseCountryFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
        }
    }

    @ViewBuilder private func content() -> some View {
        CollapsableContainer(
            collapsed: $store.isCollapsed.sending(\.onChangeCollapse)
        ) {
            collapsableContainerHeader()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .padding(.vertical, Layout.Spacing.small)
        } content: {
            collapsableContainerContent()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .padding(.vertical, Layout.Spacing.small)
        }
    }

    @ViewBuilder private func collapsableContainerHeader() -> some View {
        VStack {
            HStack {
                Text(Strings.whereText)
                Spacer()
                Text(store.searchText)
            }
            Divider()
        }
    }

    @ViewBuilder private func collapsableContainerContent() -> some View {
        VStack {
            TextField(
                Strings.searchCountryText,
                text: $store.searchText.sending(\.onChangeSearchText)
            )
            .textFieldStyle(.roundedBorder)

            searchSuggestionList()
                .frame(height: UIScreen.screenHeight * Constants.searchSuggestionHeightMultiplier)
        }
    }

    @ViewBuilder private func searchSuggestionList() -> some View {
        ScrollView {
            ForEach(store.searchResult) { item in
                searchSuggestionCell(item: item)
                    .onTapGesture {
                        store.send(.onChoseLocation(item))
                    }
            }
        }
    }

    @ViewBuilder private func searchSuggestionCell(item: SearchCity) -> some View {
        VStack {
            HStack {
                Text(item.location)
                Spacer()
            }
            Divider()
        }
        .padding(.vertical)
        .background(Colors.lightGray)
    }
}

private extension ChooseCountryView {
    enum Constants {
        static let searchSuggestionHeightMultiplier = 0.25
    }
}

#if DEBUG
    #Preview {
        ChooseCountryView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseCountryFeature()
                }
            )
        )
    }
#endif
