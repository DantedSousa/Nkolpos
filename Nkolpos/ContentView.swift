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

struct AreasView: View {
    
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
            VStack(alignment: .leading, spacing: 0) {
                
                // TÍTULO
                Text("Suas Áreas")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Divider()
                    .padding(.top, 10)
                
                // LISTA DE ÁREAS
                ForEach(areas.indices, id: \.self) { index in
                    let area = areas[index]
                    
                    NavigationLink {
                        TasksView(area: area)
                    } label: {
                        HStack {
                            Text("\(area.emoji) \(area.nome)")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            Button("Excluir") {
                                remover(area)
                            }
                            .foregroundColor(.gray)
                            
                            Button("x") {
                                remover(area)
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    
                    // DIVIDER ENTRE ITENS (EXATAMENTE COMO NO PRINT)
                    if index < areas.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
                
                // BOTÃO ADICIONAR
                Button {
                    mostrarPopup = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Adicionar")
                            .font(.title3)
                            .bold()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .navigationBarItems(
                trailing: HStack {
                    Text("Relatório")
                    Image(systemName: "chevron.right")
                }
            )
            .overlay(popup)
        }
    }
    
    // MARK: - POPUP
    @ViewBuilder
    var popup: some View {
        if mostrarPopup {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { fecharPopup() }
                
                VStack(spacing: 20) {
                    
                    Text("Nova Área")
                        .font(.title2)
                        .bold()
                    
                    TextField("Nome da área", text: $novoNome)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6)) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(6)
                                .background(emojiSelecionado == emoji ? Color.blue.opacity(0.3) : .clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    emojiSelecionado = emoji
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button("Cancelar", role: .cancel) {
                            fecharPopup()
                        }
                        
                        Spacer()
                        
                        Button("Salvar") {
                            adicionar()
                        }
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
    
    // MARK: - FUNÇÕES
    func adicionar() {
        guard !novoNome.trimmingCharacters(in: .whitespaces).isEmpty else { return }
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


import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var titulo: String
    var descricao: String
    var tempo: String
    var concluida: Bool
}

struct TasksView: View {
    
    let area: Area
    
    @State private var tasks: [Task] = [
        Task(titulo: "Título", descricao: "Descrição", tempo: "15 min", concluida: false),
        Task(titulo: "Título", descricao: "Descrição", tempo: "15 min", concluida: false),
        Task(titulo: "Título", descricao: "Descrição", tempo: "15 min", concluida: false),
        Task(titulo: "Título", descricao: "Descrição", tempo: "15 min", concluida: false)
    ]

    
    var body: some View {
        VStack {
            Text("Minhas tasks")
                .font(.largeTitle)
                .bold()
                .padding()
            
            ScrollView {
                VStack(spacing: 14) {
                    ForEach($tasks) { $task in
                        HStack {
                            Button {
                                task.concluida.toggle()
                            } label: {
                                Image(systemName: task.concluida ? "checkmark.square.fill" : "square")
                            }
                            
                            VStack(alignment: .leading) {
                                Text(task.titulo)
                                Text(task.descricao).foregroundColor(.gray)
                                Text(task.tempo).font(.caption)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5))
                        )
                    }
                }
                .padding()
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        AreasView()
    }
}

#Preview {
    ContentView()
}
