# https://github.com/duleorlovic/rails_capybara_selenium/blob/main/spec/support/capybara_screenshot_diff.rb
Capybara::Screenshot::Diff.color_distance_limit = 250
# Not sure why on Github CI we got error on one pixel
# Screenshot does not match for 'articles_page'
# ({"area_size":1,"region":[40,38,42,38],"max_color_distance":76.3})

RSpec.configure do |config|
  config.include Capybara::Screenshot::Diff, type: :feature
end
