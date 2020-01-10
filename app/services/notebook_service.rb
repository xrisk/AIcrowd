class NotebookService
  include HTTParty
  debug_output $stdout

  def initialize(notebook_url:)
    @notebook_url = notebook_url
  end

  def call
    response = HTTParty.get(@notebook_url, verify: false)
    json     = response.body
  rescue StandardError
    json = nil
  ensure
    return json
  end
end
