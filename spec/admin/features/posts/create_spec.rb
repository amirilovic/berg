require "admin_app_helper"

RSpec.feature "Admin / Posts / Create", js: true do
  include_context "admin users"

  background do
    sign_in(jane.email, jane.password)
  end

  scenario "I can create a post" do
    find("nav a", text: "Posts").trigger("click")

    find("a", text: "Add a post").trigger("click")

    find("#title").set("A sample title")
    find("#body").set("Some sample content for this post")
    find("#slug").set("a-sample-title")

    find("button", text: "Create post").trigger("click")

    expect(page).to have_content("Post has been created")

    expect(page).to have_content("A sample title")
  end

  scenario "I can see validation errors" do
    find("nav a", text: "Posts").trigger("click")

    find("a", text: "Add a post").trigger("click")

    find("#title").set("")
    find("#body").set("Some sample content for this post")
    find("#slug").set("a-sample-title")

    find("button", text: "Create post").trigger("click")

    expect(page).to have_content("must be filled")
  end
end
