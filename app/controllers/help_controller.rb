class HelpController < ApplicationController
  def index
    @topics = YAML.load_file("#{Rails.root}/config/help_topics.yml")
  end
end
