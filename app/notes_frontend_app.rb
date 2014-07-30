module Notes
  class FrontendApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :public_folder, Proc.new { File.expand_path('../public', root) }
    set :views, Proc.new { File.join(root, 'views') }

    get '/' do
      slim :boot
    end
  end
end