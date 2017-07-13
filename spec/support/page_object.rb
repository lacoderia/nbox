class PageObject
  include Capybara::DSL

  def visit_page(page)
    visit(page)
    self
  end

  def have_field?(attributes)
    find_field(attributes).visible?
  end

  def have_link?(link)
    find(:xpath, "//a[@href='#{link}']").visible?
  end

  #def save_and_open_page
  #  super
  #end

  #def login(model)
  #  fill_in 'email', with: model.email
  #  fill_in 'password', with: model.password
  #  click_on 'Submit'
  #end

  def right_path?(path, page)
    visit_page(page) && current_path == path
  end
end
