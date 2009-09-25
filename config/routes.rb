ActionController::Routing::Routes.draw do |map|
  map.connect 'syndicate/:action/feed.xml', :controller => 'syndicate'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'shelf'
end
