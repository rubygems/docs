ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'account' do |account|
    account.approve     '/account/approve',    :action => 'approve'
    account.delete_user '/account/delete/:id', :action => 'delete'
    account.login       '/account/login',      :action => 'login'
    account.logout      '/account/logout',     :action => 'logout'
    account.signup      '/account/signup',     :action => 'signup'
  end

  map.with_options :controller => 'book' do |book|
    book.delete_book '/book/delete/:id', :action => 'delete'
    book.edit_book   '/book/edit/:id',   :action => 'edit'
    book.new_book    '/book/new/',       :action => 'new'
  end

  map.with_options :controller => 'chapter' do |chapter|
    chapter.delete_chapter  '/chapter/delete/:id',   :action => 'delete'
    chapter.edit_chapter    '/chapter/edit/:id',     :action => 'edit'
    chapter.new_chapter     '/chapter/new/:book_id', :action => 'new'

    chapter.new_sub_chapter '/chapter/new/:book_id/:chapter_id', :action => 'new'
  end

  map.with_options :controller => 'export' do |export|
    export.export_book    '/export/book/:id',    :action => 'book'

    export.html_export    '/export/html/:id',    :action => 'html'
    export.text_export    '/export/text/:id',    :action => 'text'
    export.textile_export '/export/textile/:id', :action => 'textile'
    export.yaml_export    '/export/yaml/:id',    :action => 'yaml'
  end

  map.with_options :controller => 'page' do |page|
    page.delete_page  '/page/delete/:id',  :action => 'delete'
    page.edit_page    '/page/edit/:id',    :action => 'edit'
    page.history_page '/page/history/:id', :action => 'history'
    page.new_page     '/page/new/:id',     :action => 'new'
  end

  map.with_options :controller => 'read' do |read|
    read.book    '/read/book/:id',    :action => 'book'
    read.chapter '/read/chapter/:id', :action => 'chapter'
  end

  map.with_options :controller => 'syndicate' do |syndicate|
    syndicate.atom_feed '/syndicate/atom/feed.xml', :action => 'atom'
    syndicate.rss_feed  '/syndicate/rss/feed.xml',  :action => 'rss'
  end

  map.shelf  '/shelf/index',  :controller => 'shelf', :action => 'index'
  map.recent '/shelf/recent', :controller => 'shelf', :action => 'recent'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'shelf'
end
