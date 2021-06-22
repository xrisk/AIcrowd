module Notebooks
  class NotebookFileService < NotebookBaseService
    include ActiveModel::Model
    include S3FilesHelper

    def initialize(notebook_file)
      @notebook_file = notebook_file
    end

    def call
      notebook_file_path = file_handler
      `jupyter nbconvert --template basic --to html #{notebook_file_path}`
      filename = File.basename(notebook_file_path)
      html_filename = filename.chomp(File.extname(filename)) + (".html")
      unless File.exist?(Rails.root.join('public', 'uploads', html_filename))
        errors.add(:base, "Sorry, the notebook seems to be private. Please make it public and try again.")
        return
      end
      notebook_gist_url = `gist --private #{notebook_file_path}`
      notebook_s3_url = upload_to_s3(notebook_file_path, filename)
      notebook_html = File.read(Rails.root.join('public', 'uploads', html_filename)).html_safe
      gist_id = notebook_gist_url.strip.gsub(ENV['GIST_URL'], "")
      File.delete(notebook_file_path) if File.exist?(notebook_file_path)
      File.delete(Rails.root.join('public', 'uploads', html_filename)) if File.exist?(Rails.root.join('public', 'uploads', html_filename))

       return {notebook_s3_url: notebook_s3_url, notebook_html: notebook_html, gist_id: gist_id}
    end

    def file_handler
      filename = "#{SecureRandom.uuid}.ipynb"
      notebook_file_path = Rails.root.join('public', 'uploads',filename)
      File.open(notebook_file_path, 'wb'){ |file| file.write(@notebook_file.read)}
      return notebook_file_path
    end

  end
end
