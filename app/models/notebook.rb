class Notebook < ApplicationRecord
  belongs_to :notebookable, polymorphic: true

  COLAB_URL = ENV['COLAB_URL']
  GIST_URL = ENV['GIST_URL']
  USER_NAME = ENV['GIST_USERNAME']

  def execute_in_colab_url
    colab_url = nil
    if self.gist_id.present?
      colab_url = COLAB_URL + USER_NAME + '/' + self.gist_id
    end
    return colab_url
  end
end
