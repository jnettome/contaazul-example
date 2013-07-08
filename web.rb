# encoding: utf-8
require 'sinatra'
require 'contaazul'
require 'json'

before do
  content_type :html, 'charset' => 'utf-8'
end

enable :sessions

get '/' do
  Contaazul.external_token = "0000013f-aa0e-57a8-0000-00000000a50f"
  Contaazul.return_url = "http://localhost:4567/return"

  options = { :company_token => session[:company_token] } if session[:company_token]
  @client = Contaazul::Client.new(options || {})

  @is_logged_in = session[:company_token]
  erb :index
end

get '/return' do
  session[:company_token] = params[:authorizationToken]

  "<script>window.opener.location.reload(); window.close();</script>"
end

get '/clients' do
  @client = Contaazul::Client.new(:company_token => session[:company_token])

  @record_type = "Clients"
  @records = JSON.parse(@client.clients)
  puts @records.inspect

  erb :records
end

post '/clients/create' do
  @client = Contaazul::Client.new(:company_token => session[:company_token])
  @record = JSON.parse(@client.create_client(params[:record]))
  puts @record.inspect
  @record
end

get '/clients/:id' do
  @client = Contaazul::Client.new(:company_token => session[:company_token])

  @record_type = "Client #{params[:id]}"
  @record = @client.client(params[:id])

  erb :single_record
end

get '/logout' do
  session.clear

  redirect '/'
end
