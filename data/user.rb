class User
  attr_accessor :id, :name, :email, :password, :errors
  
  def initialize(params = {})
    self.id = params[:id] || params['id']
    self.name = params[:name] || params['name']
    self.email = params[:email] || params['email']
    self.password = params[:password] || params['password']
    self.errors = params[:errors] || params['errors'] || []
  end

end