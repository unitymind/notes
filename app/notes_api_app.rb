module Notes
  class ApiApp
    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Notes::ApiApp.new
      end.to_app
    end

    def call(env)
      Notes::API.call(env)
    end
  end
end