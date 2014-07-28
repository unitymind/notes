module Notes
  class API < Grape::API
    format :json
    default_format :json
    default_error_formatter :json
    cascade false

    rescue_from ::ActiveRecord::RecordNotFound do |e|
      message = { error: e.message }
      rack_response(format_message(message, e.backtrace), 404 )
    end

    rescue_from ::ActiveRecord::RecordInvalid do |e|
      message = { error: e.message }
      rack_response(format_message(message, e.backtrace), 422 )
    end

    helpers do
      def permitted_params
        @permitted_params ||= declared(params, include_missing: false)
      end
    end

    namespace :notes do
      desc 'Returns all Note items'
      get do
        present :notes, ::Notes::Note.all
      end

      params do
        requires :note, type: Hash do
          requires :title, type: String
        end
      end
      desc 'Create Note item'
      post do
        present :note, ::Notes::Note.create!(permitted_params[:note])
      end

      params do
        requires :id, type: Integer
      end
      route_param :id do
        desc 'Returns Note item by id'
        get do
          present :note, ::Notes::Note.find(permitted_params[:id])
        end

        desc 'Delete Note item by id'
        delete do
          ::Notes::Note.find(permitted_params[:id]).destroy
          status(204)
        end
      end
    end
  end
end