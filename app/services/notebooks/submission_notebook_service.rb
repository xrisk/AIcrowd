module Notebooks
  class SubmissionNotebookService < NotebookBaseService
    include ActiveModel::Model
    include S3FilesHelper

    def initialize(submission)
      @folder_name = "#{SecureRandom.uuid}"
      submission_file = submission.submission_files.first
      @url = submission_file.submission_file_s3_key
      @file_name = submission_file.submission_file_s3_key.split('/').last.split('.').first
      @notebook_name = submission.meta['private_generate_notebook_section_file_name']
    end

    def call
      notebook_file_path = process_zip_file
      `jupyter nbconvert --template basic --to html #{notebook_file_path}`

      filename = File.basename(notebook_file_path)
      html_filename = filename.chomp(File.extname(filename)) + (".html")
      html_filename_path = Rails.root.join('public', 'uploads', @folder_name, html_filename)

      notebook_gist_url = `gist --private #{notebook_file_path}`
      notebook_s3_url = upload_to_s3(notebook_file_path, filename)
      notebook_html = File.read(html_filename_path).html_safe
      gist_id = notebook_gist_url.strip.gsub(ENV['GIST_URL'], "")

      FileUtils.rm_rf(Rails.root.join('public', 'uploads', @folder_name))
      File.delete(Rails.root.join('public', 'uploads', "#{@file_name}.zip")) if File.exist?(Rails.root.join('public', 'uploads', "#{@file_name}.zip"))

      return {notebook_s3_url: notebook_s3_url, notebook_html: notebook_html, gist_id: gist_id}
    end

    def process_zip_file
      download_url = s3_expiring_url(@url)
      download = open(download_url) rescue nil
      return if download.nil?
      file_name = "#{@file_name}.zip"
      file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
      IO.copy_stream(download, file_path)
      return unzip_file(file_path)
    end

    def unzip_file(file_path)
      Zip::File.open(file_path) do |zip_file|
        zip_file.glob("#{@notebook_name}").each do |f|
           f_path=File.join('public', 'uploads', @folder_name, f.name)
           FileUtils.mkdir_p(File.dirname(f_path))
           zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
      return Rails.root.join('public', 'uploads', @folder_name, @notebook_name)
    end

  end
end
