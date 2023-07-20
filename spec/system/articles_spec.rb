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
