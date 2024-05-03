//
//  EarningsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

public struct EarningsView: View {
    @Perception.Bindable private var store: StoreOf<EarningsFeature>

    public init(store: StoreOf<EarningsFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            FHContentView(
                title: Strings.earningsTabTitle,
                configuration: .init(horizontalPadding: Layout.Spacing.smallMedium)
            ) {
                VStack {
                    Spacer()
                    if store.isLoading {
                        ProgressView(Strings.loadingText)
                    } else {
                        content()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            controlsView()
                .padding(.top, -Layout.Spacing.small)

            if !store.isLoading && store.earnings.isEmpty {
                Spacer()
                Text(Strings.noDataText)
                Spacer()
            } else {
                chartListView()
            }
        }
    }

    @ViewBuilder private func chartListView() -> some View {
        if !store.isChartHidden {
            ChartView(
                earnings: store.earnings
            )
            .frame(height: 300)
        }

        listContent()
    }

    @ViewBuilder private func controlsView() -> some View {
        HStack {
            Button {
                store.send(.onPrevMonthTapped,
                           animation: .linear(duration: 0.2))
            } label: {
                Icons.chevronLeft
                    .padding(.all, Layout.Spacing.small)
            }

            Button {
                if !store.isChartHidden {
                    store.send(.onMonthTapped)
                }
            } label: {
                Spacer()
                Text(store.formattedMonth)
                Spacer()
            }

            Button {
                store.send(.onNextMonthTapped,
                           animation: .linear(duration: 0.2))
            } label: {
                Icons.chevronRight
                    .padding(.all, Layout.Spacing.small)
            }
        }
        .font(.title2)
        .foregroundStyle(Colors.label)
    }

    @ViewBuilder private func listContent() -> some View {
        VStack(alignment: .leading) {
            Text(
                String(
                    format: "\(Strings.earnedText) \(Strings.pendingText)",
                    store.earnedProfit, store.pendingProfit
                )
            )
            List {
                ForEach(store.earnings) { item in
                    EarningCell(earningModel: item)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#if DEBUG
    #Preview {
        EarningsView(
            store: .init(
                initialState: .init(), reducer: {
                    EarningsFeature()
                }
            )
        )
    }
#endif
