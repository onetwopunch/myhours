module API
  class UserAPI < Grape::API
    helpers do
      def current_user
        @current_user ||= ::User.find_by_token(params[:private_token])
      end
    end
    resource 'users' do
       
      get :entries do
        ::User.find_by_token(params[:private_token]).entry_array
      end
    end
  end
end


