//
//  ContentView.swift
//  Nkolpos
//
//  Created by found on 05/12/25.
//

import SwiftUI

struct Area: Identifiable, Equatable {
    let id = UUID()
    var emoji: String
    var nome: String
}

struct ContentView: View {
    
    @State private var areas = [
        Area(emoji: "📚", nome: "Estudos"),
        Area(emoji: "🏋️‍♂️", nome: "Academia")
    ]
    
    @State private var mostrarPopup = false
    @State private var novoNome = ""
    @State private var emojiSelecionado = "✨"
    
    let emojis = ["📚","🏋️‍♂️","💼","🎮","🎨","💡","🚀","📖","💻","✨","🔥","🎧"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                titulo
                
                Divider()
                
                listaDeAreas
                
                botaoAdicionar
                
                Spacer()
            }
            .navigationBarItems(trailing: relatorio)
            .overlay(popup)
        }
    }
    
    // MARK: Componentes
    
    var titulo: some View {
        Text("Suas Áreas")
            .font(.largeTitle).bold()
            .padding(.top, 20)
    }
    
    var listaDeAreas: some View {
        ForEach(areas) { area in
            HStack {
                Text("\(area.emoji) \(area.nome)")
                    .font(.title3).bold()
                
                Spacer()
                
                Button("Excluir") { remover(area) }
                    .foregroundColor(.gray)
                
                Button("x") { remover(area) }
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
    }
    
    var botaoAdicionar: some View {
        Button {
            mostrarPopup = true
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Adicionar").font(.title3).bold()
            }
        }
        .padding(.horizontal)
    }
    
    var relatorio: some View {
        HStack {
            Text("Relatório")
            Image(systemName: "chevron.right")
        }
    }
    
    // MARK: Popup
    @ViewBuilder
    var popup: some View {
        if mostrarPopup {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { fecharPopup() }
                
                VStack(spacing: 20) {
                    
                    Text("Nova Área").font(.title2).bold()
                    
                    TextField("Nome da área", text: $novoNome)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6)) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(6)
                                .background(emoji == emojiSelecionado ? Color.blue.opacity(0.3) : .clear)
                                .cornerRadius(10)
                                .onTapGesture { emojiSelecionado = emoji }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button("Cancelar", role: .cancel) { fecharPopup() }
                        Spacer()
                        Button("Salvar") { adicionar() }
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
            }
        }
    }
    
    // MARK: Funções
    
    func adicionar() {
        guard !novoNome.isEmpty else { return }
        areas.append(Area(emoji: emojiSelecionado, nome: novoNome))
        fecharPopup()
    }
    
    func remover(_ area: Area) {
        areas.removeAll { $0 == area }
    }
    
    func fecharPopup() {
        novoNome = ""
        emojiSelecionado = "✨"
        mostrarPopup = false
    }
}

#Preview {
    ContentView()
}
