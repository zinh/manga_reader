MangaSearch::Application.routes.draw do
  controller :homes do
    post '/manga/search' => :search, as: 'manga_search'
    post '/manga/detail' => :manga_detail, as: 'manga_detail'
    post '/manga/chapter' => :manga_chapter
    get '/manga' => :manga_search, as: 'manga_index'
  end
  root to: 'homes#index'
end
