# Rails Visual test using capybara screenshot

Test you web page using screenshots so you can detect visual changes.

## Install rspec

On rails app add rspec and generate scaffold articles

```
bundle add rspec-rails --group "development, test"
rails generate rspec:install
git add . && git commit -m'rails generate rspec:install'


rails g scaffold articles title body:text
rails db:create db:migrate
sed -i -e '/end/i\
  root "articles#index"
' config/routes.rb
git add . && git commit -m'rails g scaffold articles title body:text'
```

check if you can run tests successfully
```
rspec
Finished in 0.20697 seconds (files took 1.23 seconds to load)
27 examples, 0 failures, 14 pending
```

## Capybara system test

To run system test we need capybara and webdrivers which is included by default
in rails Gemfile. If they are not present, add them
```
# Gemfile
group :test do
  gem "capybara"
  gem "webdrivers"
end
```
create some system test and configure to work in headless_chrome
```
# spec/support/capybara_selenium.rb
# https://github.com/duleorlovic/rails_capybara_selenium/blob/main/spec/support/capybara_selenium.rb
RSpec.configure do |config|
  config.before :each, type: :system do
    if ENV["USE_HEADFULL_CHROME"].present?
      # Use chrome only on local machine since CI will fail
      # export USE_HEADFULL_CHROME=true
      # rails test:system
      # unset USE_HEADFULL_CHROME
      driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
    else
      # driven_by :selenium_chrome_headless
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    end
  end
end
```

so we can run

```
# rspec/system/articles_spec.rb
require 'rails_helper'

RSpec.describe "Articles", type: :system do
  it "see articles page" do
    visit articles_path
    expect(page.body).to include  "Articles"
  end
end
```

in both headless and headfull mode

```
rspec spec/system/articles_spec.rb
```

For error `Webdrivers::VersionError:` please look at
https://github.com/duleorlovic/rails_capybara_selenium#chrome-version

## Visual test

Now we can play with screenshots by adding to Gemfile

```
group :test do
  gem 'capybara-screenshot-diff'
  gem 'oily_png', platform: :ruby
end
```

add configuration
```
# spec/support/capybara_screenshot_diff.rb
# https://github.com/duleorlovic/rails_capybara_selenium/blob/main/spec/support/capybara_screenshot_diff.rb
Capybara::Screenshot::Diff.color_distance_limit = 80
# Not sure why on Github CI we got error on one pixel
# Screenshot does not match for 'articles_page' ({"area_size":1,"region":[40,38,42,38],"max_color_distance":76.3})

RSpec.configure do |config|
  config.include Capybara::Screenshot::Diff
end
```

and adding a line
```
# rspec/system/articles_spec.rb
    screenshot "articles_page"
```

so now when you run the test it will generate file since it does not exists

```
rspec spec/system/articles_spec.rb
1 example, 0 failures
# doc/screenshots/articles_page.png is generated
```

so you can commit and push
```
git add .
git commit -am'Add screenshot test'
git push
```

Test will fail if there are some visual differences.
On CI you can download artifacts.

## Similar

Blog from 2016 https://medium.com/@yoooodaaaa/visual-regression-testing-in-capybara-6c147fdceee6
gist https://gist.github.com/sb8244/55246c51e469524f2abd0c17dd3c574e
suggests using
```
image = page.save_screenshot(image_path)
# .crop
cropped_image = Magick::Image.read(image)[0].crop(location.x - padding/2, location.y - padding/2, size.width + padding, size.height + padding)
# .compare_channel
diff_image, pixels_changed = existing_image.compare_channel(image, Magick::AbsoluteErrorMetric)
```

gem 'rspec-visual' from 2016 https://github.com/rambler-digital-solutions/rspec-visual

Most recent gem capybara-screenshot-diff https://github.com/donv/capybara-screenshot-diff
