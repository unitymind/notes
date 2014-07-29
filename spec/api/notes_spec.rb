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

    context 'GET /notes' do
      it 'returns an empty array of notes' do
        get '/notes'
        expect(last_response.status).to eql 200
        parsed = JSON.parse(last_response.body)
        expect(parsed).to have_key 'notes'
        expect(parsed['notes']).to be_a_kind_of Array
        expect(parsed['notes']).to be_empty
      end
    end

    context 'GET /notes/{id}' do
      it 'returns a note by id' do
        note = create(Note.singular_sym)
        get "/notes/#{note.id}"
        expect(last_response.status).to eql 200
        parsed = JSON.parse(last_response.body)
        expect(parsed).to have_key 'note'
        expect(parsed['note']['id']).to eql note.id
        expect(parsed['note']['title']).to eql note.title
        expect(parsed['note']['created_at']).to eql note.created_at.to_json.gsub('"', '').gsub('/', '-')
        expect(parsed['note']).to_not have_key 'updated_at'
      end
    end

    context 'GET /notes/{missed_id}' do
      it 'returns a 404 for wrong id' do
        get '/notes/789'
        expect(last_response.status).to eql 404
      end
    end

    context 'GET /notes/{missed_format_id}' do
      it 'returns a 400 for missed format for id' do
        get '/notes/d8h10'
        expect(last_response.status).to eql 400
      end
    end

    context 'POST /notes' do
      it 'returns 201 and created a new note' do
        params = { note: {title: Faker::Lorem.sentence} }
        post '/notes', params.merge({format: :json})
        expect(last_response.status).to eql 201
        parsed = JSON.parse(last_response.body)
        expect(parsed).to have_key 'note'
        expect(parsed['note']).to have_key 'id'
        expect(parsed['note']['title']).to eql params[:note][:title]
        expect(parsed['note']).to have_key 'created_at'
      end
    end

    context 'DELETE /notes/{id}' do
      it 'delete a note by id and returns 204' do
        note = create(Note.singular_sym)
        delete "/notes/#{note.id}"
        expect(last_response.status).to eql 204
        expect(last_response.body).to be_empty
      end
    end

    context 'GET /missed_api_route' do
      it 'returns 404 with error message' do
        get '/missed_api_route'
        expect(last_response.status).to eql 404
        parsed = JSON.parse(last_response.body)
        expect(parsed).to have_key 'error'
        expect(parsed['error']).to eql 'Route not found'
      end
    end
  end
end