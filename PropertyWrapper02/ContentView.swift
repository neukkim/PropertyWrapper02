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
    
    @State private var newPost = Post(username: "유저 이름", content: "")
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($list) { $post in
                    NavigationLink {
                        PostDetail(post: $post)
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
            NavigationView {
                PostAdd(editingPost: $newPost)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                                newPost = Post(username: "유저 이름", content: "")
                                showAddView = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("게시") {
                                list.insert(newPost, at:0)
                                showAddView = false
                                newPost = Post(username: "유저 이름", content: "")
                                
                            }
                        }
                        
                    }
            }
        }
    }
}

struct PostDetail: View {
    @State private var showEditView: Bool = false
//    let post: Post
    @Binding var post: Post
    @State private var editingPost = Post(username: "유저 이름", content: "")
    
    var body: some View {
        VStack(spacing: 20) {
            Text(post.username)
            Text(post.content)
                .font(.largeTitle)
            Button {
                editingPost = post
                showEditView = true
            } label: {
                Image(systemName: "pencil")
                Text("수정")
            }
            .fullScreenCover(isPresented: $showEditView) {
                NavigationView {
                    PostAdd(editingPost: $editingPost)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("취소") {
                                    showEditView = false }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("게시") {
                                    post = editingPost
                                    showEditView = false
                                }
                            }
                        }
                }
            }
        }
    }
}

struct PostAdd: View {
    @FocusState private var focused: Bool
    @Binding var editingPost: Post
    

    
    var body: some View {
        VStack {
            TextField("포스트를 입력해 주세요..", text: $editingPost.content)
                .font(.title)
                .padding()
                .padding(.top)
                .focused($focused)
                .onAppear { focused = true }
            Spacer()
        }
        .navigationTitle("포스트 게시")
        .navigationBarTitleDisplayMode(.inline)
        
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
    var content:String
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
