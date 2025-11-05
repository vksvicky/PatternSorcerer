//
//  ResizableSidebarSplit.swift
//  PatternSorcerer
//
//  A simple, reusable split layout with a resizable fixed-width left sidebar.
//  Uses an HStack with a draggable divider so runtime resizing is reliable
//  and predictable across previews and the running app.
//

import SwiftUI

struct ResizableSidebarSplit<Sidebar: View, Content: View>: View {
    let minSidebarWidth: CGFloat
    let maxSidebarWidth: CGFloat
    let initialSidebarWidth: CGFloat
    let sidebar: () -> Sidebar
    let content: () -> Content

    @State private var sidebarWidthInternal: CGFloat

    init(
        minSidebarWidth: CGFloat = 240,
        maxSidebarWidth: CGFloat = 240,
        initialSidebarWidth: CGFloat = 280,
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minSidebarWidth = minSidebarWidth
        self.maxSidebarWidth = maxSidebarWidth
        self.initialSidebarWidth = initialSidebarWidth
        self.sidebar = sidebar
        self.content = content
        _sidebarWidthInternal = State(initialValue: initialSidebarWidth)
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar()
                .frame(width: sidebarWidthInternal)

            divider

            content()
                .frame(minWidth: 400)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(nsColor: .separatorColor))
            .frame(width: 1)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 8)
                    .contentShape(Rectangle())
                    .gesture(dragGesture)
                    .onHover { hovering in
                        if hovering {
                            NSCursor.resizeLeftRight.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
            )
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let proposed = sidebarWidthInternal + value.translation.width
                sidebarWidthInternal = max(minSidebarWidth, min(maxSidebarWidth, proposed))
            }
    }
