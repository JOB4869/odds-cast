require "rails_helper"

RSpec.describe "Articles management", type: :feature do
  it_should_behave_like "Contents"
  before do
    # Create an article to be used in other tests
    @article = Admin::Article.create!(
      title: "Test Article",
      description: "Test description",
    )
  end

  it "allows creating an article with image upload" do
    visit 'admin/articles/new'

    fill_in 'Title', with: 'test7'
    fill_in 'Description', with: 'test7777'
    # Upload a new image
    attach_file('Photo', './spec/fixture/test1.jpeg')

    click_on 'Create Article'

    expect(page).to have_content('test7')
    expect(page).to have_content('test7777')
    expect(page).to have_css("img[src*='test1.jpeg']")  # Check if the image is displayed
  end

  it "lists articles with images" do
    visit 'admin/articles'

    expect(page).to have_content('Test Article')
    expect(page).to have_content('Test description')
    expect(page).to have_css("img[src*='test1.jpeg']")  # Check if the image is listed
  end

  it "allows editing an article and updating the image" do
    visit 'admin/articles'
    click_on 'Show this article'
    click_on 'Edit this article'

    fill_in 'Title', with: 'Updated Test Article'
    fill_in 'Description', with: 'Updated description'

    # Upload a new image
    attach_file('Photo', './spec/fixture/test1.jpeg')

    click_on 'Update Article'

    expect(page).to have_content('Updated Test Article')
    expect(page).to have_content('Updated description')
    expect(page).to have_css("img[src*='test1.jpeg']")  # Check if the new image is displayed
  end

  it "deletes an article" do
    visit 'admin/articles'
    click_on 'Show this article'
    click_on 'Destroy this article'

    expect(page).to have_content('Article was successfully destroyed.')
    visit admin_articles_path

    expect(page).not_to have_content('Test Article')
  end
end
