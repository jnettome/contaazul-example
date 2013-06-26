# encoding: utf-8
require 'sinatra'
require 'contaazul'

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  Contaazul.client_secret = "00000000-0000-0000-0000-000000000000"
  @client = Contaazul::Client.new

  erb :index
end
