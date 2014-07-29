module Notes
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      Notes::ApiApp.instance
    end

    context 'CORS' do
      it 'supports options' do
        options '/', {},
                'HTTP_ORIGIN' => 'http://cors.example.com',
                'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'Origin, Accept, Content-Type',
                'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET'

        expect(last_response.status).to eql 200
        expect(last_response.headers['Access-Control-Allow-Origin']).to eql 'http://cors.example.com'
        expect(last_response.headers['Access-Control-Expose-Headers']).to eql ''
      end

      it 'includes Access-Control-Allow-Origin in the response' do
        get '/notes', {}, 'HTTP_ORIGIN' => 'http://cors.example.com'
        expect(last_response.status).to eql 200
        expect(last_response.headers['Access-Control-Allow-Origin']).to eql 'http://cors.example.com'
      end
      it 'includes Access-Control-Allow-Origin in errors' do
        get '/invalid', {}, 'HTTP_ORIGIN' => 'http://cors.example.com'
        expect(last_response.status).to eql 404
        expect(last_response.headers['Access-Control-Allow-Origin']).to eql 'http://cors.example.com'
      end
    end
  end
end