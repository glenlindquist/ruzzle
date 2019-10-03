require 'bundler'
Bundler.require

opal = Opal::Sprockets::Server.new {|s|
  s.append_path 'app'
  s.main = 'application'
}

sprockets   = opal.sprockets
prefix      = '/assets'

map prefix do
  run sprockets
end

# get '/' do
#   <<-HTML
#     <!doctype html>
#     <html>
#       <head>
#         <meta charset="utf-8">
#         #{::Opal::Sprockets.javascript_include_tag('application', sprockets: sprockets, prefix: prefix, debug: false)}
#       </head>
#       <body>
#       </body>
#     </html>
#   HTML
# end

require './app'
run Sinatra::Application
