class Admin::LogsController < ApplicationController
  def index
    authorize! :manage, :all

    @logs = AppLog.order("created_at DESC")
  end
end
