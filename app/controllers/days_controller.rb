class DaysController < ApplicationController
  before_action :authenticate_user!, only: [:index,:record,:new,:create,:weight]
  def index
    @user = current_user
  end

  def new
  end

  def create
  end

  def weight
  end

  def record
  end
end