module Notes
  class FrontendApp < Sinatra::Base
    set :public_folder, Proc.new { File.expand_path('../public', root) }

  end
end