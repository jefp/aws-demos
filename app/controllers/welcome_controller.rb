class WelcomeController < ApplicationController
  def index
  end
  def burn 
    @t=rand(10000000)
    @t.times do |d|
      rand(100)*rand(100)
    end
  end
end
