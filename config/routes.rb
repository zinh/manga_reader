Rails.application.routes.draw do
  controller :homes do
    post '/manga/search' => :search, as: 'manga_search'
    post '/manga/detail' => :manga_detail, as: 'manga_detail'
    post '/manga/chapter' => :manga_chapter
    get '/manga' => :manga_search, as: 'manga_index'
  end

  controller :partials do
    get '/partials/manga-chapter.html' => :manga_chapter
    get '/partials/manga-detail.html' => :manga_detail
    get '/partials/search-form.html' => :search_form
  end

  root to: 'homes#index'
end
