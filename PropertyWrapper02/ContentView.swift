//
//  ContentView.swift
//  PropertyWrapper02
//
//  Created by SunMin Hong on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                Forum()
                    .tabItem {
                        Image(systemName: "bubble.right")
                    }
                Text("두번째 탭")
                    .tabItem {
                        Image(systemName: "house")
                    }
            }
            .navigationTitle("M 스터디 방")
        }
    }
}

struct Forum: View {
    @State private var list: [Post] = Post.list
    @State private var showAddView: Bool = false
    
    @StateObject var postVM = PostViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(list) { post in
                    NavigationLink {
                        PostDetail(post: post, postVM: postVm)
                    } label: {
                        PostRow(post: post)
                    }
                    .tint(.primary)
                }
            }
        }
        .refreshable { }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button {
                showAddView = true
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .padding()
                    .background(Circle().fill(.white).shadow(radius: 4))
            }
            .padding()
        }
        .sheet(isPresented: $showAddView) {
            PostAdd(postVm: postVM)
        }
    }
}

struct PostDetail: View {
    @State private var showEditView: Bool = false
    let post: Post
    
    @ObservedObject var postVM: PostViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(post.username)
            Text(post.content)
                .font(.largeTitle)
            Button {
                showEditView = true
            } label: {
                Image(systemName: "pencil")
                Text("수정")
            }
            .sheet(isPresented: $showEditView) {
                PostAdd(postVm: postVM)
            }
        }
    }
}

class PostViewModel: ObservableObject {
    @Published var list: [Post] = Post.list
    
    func addPost(text: String) {
        let newPost = Post(username: "유저이름", content: text)
        list.insert(newPost, at: 0)
    }
}

struct PostAdd: View {
    @FocusState private var focused: Bool
    
    //아래 추가 공부 필요
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    
    @ObservedObject var postVm: PostViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("포스트를 입력해 주세요..", text: $text)
                    .font(.title)
                    .padding()
                    .padding(.top)
                    .focused($focused)
                    .onAppear { focused = true }
                Spacer()
            }
            .navigationTitle("포스트 게시")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss()}
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("게시") {
                        postVm.addPost(text: text)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PostRow: View {
    let post: Post
    let colors: [Color] = [
        Color.orange, Color.green, Color.pink, Color.blue, Color.yellow, Color.brown, Color.cyan, Color.purple
    ]
    var body: some View {
        HStack {
            Circle()
                .fill(colors.randomElement() ?? . brown)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(post.username)
                Text(post.content)
                    .font(.title)
            }
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
        }
        .padding()
    }
}

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let content:String
}

extension Post {
    static var list: [Post] = [
        Post(username: "나니", content: "나나냐"),
        Post(username: "루니", content: "루루루니"),
        Post(username: "호날두", content: "오호오호"),
        Post(username: "쿠가", content: "쿠쿠다쿠"),
        Post(username: "나나", content: "나나다"),
        Post(username: "긴가", content: "긴가민가"),
        Post(username: "헤호", content: "헤헤호호다")
        
    ]
}

#Preview {
    //    ContentView()
    //    PostRow(post: Post(username: "스티그", content: "헤이 안녕"))
    //    PostDetail(post: Post(username: "스티그!", content: "헤이 안녕!"))
    //    PostAdd()
    //    PostAdd() { post in }
//    NavigationView {
//        Forum()
//    }
    ContentView()
}
