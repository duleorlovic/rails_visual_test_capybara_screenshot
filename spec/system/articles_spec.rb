require 'rails_helper'

RSpec.describe "Articles", type: :system do
  include Capybara::Screenshot::Diff

  it "see articles page" do
    visit articles_path
    screenshot "articles_page"
    expect(page.body).to include  "Articles"
  end
end
