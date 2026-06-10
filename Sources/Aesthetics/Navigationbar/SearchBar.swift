//
//  SearchBar.swift
//  Aesthetics
//
//  Created by Aarav Gupta on 10/06/26.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var prompt: String
    var onSubmit: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
                
                TextField(prompt, text: $text)
                    .font(.body)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .modifier(SearchBarBackgroundModifier())
            
            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .font(.body)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .foregroundStyle(.red)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .padding(.horizontal)
    }
}

struct SearchBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
//                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .glassEffect(.regular)
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
