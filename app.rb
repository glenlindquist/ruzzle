require 'sinatra'
require 'opal'

INIT_GRID = IO.read('app/application.rb')

DRAW_CANVAS = "
\n$document.ready do\n
puts 'Ready'\n
canvas.append_to($document.body)\n
puts 'Finished'\n
end
"

get '/' do
  rb_string = [INIT_GRID, DRAW_CANVAS].join("\n")

  builder = Opal::Builder.new
  builder.build_str(rb_string, '(inline)')
  @compiled_js = builder.to_s

  erb :home
end

post '/ruzzle' do
  user_input = params[:ruzzle_content]
  rb_string = [INIT_GRID, user_input, DRAW_CANVAS].join("\n")

  builder = Opal::Builder.new
  builder.build_str(rb_string, '(inline)')
  @compiled_js = builder.to_s

  erb :home
end