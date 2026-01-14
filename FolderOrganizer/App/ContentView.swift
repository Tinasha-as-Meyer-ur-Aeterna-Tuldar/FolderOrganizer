// FolderOrganizer/App/ContentView.swift
//
// RenameFlowState によるルート View 制御（v0.2）
//

import SwiftUI

struct ContentView: View {

    @State private var flowState: RenameFlowState = .welcome

    var body: some View {
        switch flowState {

        case .welcome:
            WelcomeView { rootURL in
                let engine = RenamePlanEngine()
                let plans = engine.buildPlans(from: rootURL)

                flowState = .preview(
                    rootURL: rootURL,
                    plans: plans,
                    selectionIndex: plans.isEmpty ? nil : 0,
                    showSpaceMarkers: true
                )
            }

        case let .preview(rootURL, plans, selectionIndex, showSpaceMarkers):
            PreviewListContentView(
                plans: plans,
                selectionIndex: selectionIndex,
                showSpaceMarkers: showSpaceMarkers,
                onSelect: { index in
                    flowState = .preview(
                        rootURL: rootURL,
                        plans: plans,
                        selectionIndex: index,
                        showSpaceMarkers: showSpaceMarkers
                    )
                },
                onCommit: { index, newName in
                    var updatedPlans = plans
                    updatedPlans[index] =
                        plans[index].updatingFinalName(newName)

                    flowState = .preview(
                        rootURL: rootURL,
                        plans: updatedPlans,
                        selectionIndex: index,
                        showSpaceMarkers: showSpaceMarkers
                    )
                }
            )

        case .applying:
            Text("Applying...")

        case .result:
            Text("Result")
        }
    }
}
