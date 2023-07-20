# Rails Visual test using capybara screenshot

Test you web page using screenshots so you can detect visual changes.

## Install rspec

On rails app add rspec and generate scaffold articles

```
bundle add rspec-rails
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
create some system test
```
# rspec/system/articles_spec.rb
require 'rails_helper'

RSpec.describe "Articles", type: :system do
  before do
    driven_by(:selenium)
  end

  it "see articles page" do
    visit articles_path
    expect(page.body).to include  "Articles"
  end
end
```

and run

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

and adding a line
```
# rspec/system/articles_spec.rb
  include Capybara::Screenshot::Diff

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

Note that we need to mark js: true and use fixtures (so the content does not
change)

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
