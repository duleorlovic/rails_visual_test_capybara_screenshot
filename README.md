# Rails Visual test using capybara screenshot

Test you web page using screenshots so you can detect visual changes.

## Prepare

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

we can run test
```
rspec
```

Also we need to add webdrivers and capybara so we can write system test.

Now we can play with screenshots

```
gem 'capybara-screenshot-diff'
gem 'oily_png', platform: :ruby
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
