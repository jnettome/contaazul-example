# encoding: utf-8
require 'sinatra'
require 'contaazul'
require 'json'

before do
  content_type :html, 'charset' => 'utf-8'
end

enable :sessions

get '/' do
  Contaazul.external_token = ENV["CONTAAZUL_TOKEN"]
  Contaazul.return_url = "#{request["REQUEST_URI"]}/return"

  options = { :company_token => session[:company_token] } if session[:company_token]
  @client = Contaazul::Client.new(options || {})

  @is_logged_in = session[:company_token]
  erb :index
end

get '/return' do
  session[:company_token] = params[:authorizationToken]

  "<script>parent.location.reload(); window.close();</script>"
end

get '/clients' do
  @client = Contaazul::Client.new(:company_token => session[:company_token])

  @record_type = "Clients"
  @records = JSON.parse(@client.clients)

  erb :records
end

get '/clients/:id' do
  @client = Contaazul::Client.new(:company_token => session[:company_token])

  @record_type = "Client #{params[:id]}"
  @record = @client.client(params[:id])

  erb :single_record
end
