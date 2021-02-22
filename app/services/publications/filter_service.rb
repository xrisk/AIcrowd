module Publications
  class FilterService
    def initialize(params)
      @params = params
      @publications = Publication.all
    end

    def call
      # category filter
      @publications = @publications.joins(:categories).group('publications.id').where('categories.name IN (?)', @params['categories'].split(',')) if @params.dig('categories').present?
      #  filter
      @publications = @publications.joins(:venues).group('publications.id').where('short_name IN (?)', @params['venues'].split(',')) if @params.dig('venues').present?
      # year filter
      if @params[:years].present?
        @params[:years].split(',').each do |year|
          @publications = @publications.where('extract(year from publication_date) = ?', year.to_i)
        end
      end

      @publications
    end
  end
end