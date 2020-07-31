namespace :category do
  desc 'Remove prefixed hash from categories'
  task remove_prefixed_hash_from_categories: :environment do
    prefixed_hash_categories = Category.all.where('name LIKE ?', '#%')
    prefixed_hash_categories.each do |category|
      category.update(name: category.name.gsub('#', ''))
    end
  end
end
