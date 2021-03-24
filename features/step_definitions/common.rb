When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect("#{Capybara.app_host}#{URI.parse(current_url).path}").to eql("#{Capybara.app_host}#{page_name}")
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_text(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_text(text)
end

And(/^I should see subsection "([^"]*)"$/) do |text|
  expect(page).to have_css('span.govuk-caption-xl', exact_text: text)
end

Then(/^I should see a "([^"]*)" link to "([^"]*)"$/) do |text, href|
  expect(page).to have_link(text, href: href)
end

When(/^I click the "([^"]*)" link$/) do |text|
  click_link(text)
end

When(/^I click the "([^"]*)" button$/) do |text|
  click_button(text)
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I click the radio button "([^"]*)"$/) do |text|
  find('label', exact_text: text).click
end

When(/^I choose "([^"]*)"$/) do |text|
  step %[I click the radio button "#{text}"]
  step %[I click the "Continue" button]
end

And(/^I choose "([^"]*)" and fill in "([^"]*)" with "([^"]*)"$/) do |text, field, value|
  step %[I click the radio button "#{text}"]
  step %[I fill in "#{field}" with "#{value}"]
  step %[I click the "Continue" button]
end

When(/^I am completing a basic under 18 "([^"]*)" conviction$/) do |value|
  step %[I have started a check]
  step %[I should see "Were you cautioned or convicted?"]
  step %[I choose "Convicted"]
  step %[I should see "How old were you when you got convicted?"]
  step %[I choose "Under 18"]
  step %[I should see "When were you convicted?"]
  step %[I enter a valid date]
  step %[I should see "What type of conviction did you get?"]
  step %[I choose "#{value}"]
end

When(/^I am completing a basic 18 or over "([^"]*)" conviction$/) do |value|
  step %[I have started a check]
  step %[I should see "Were you cautioned or convicted?"]
  step %[I choose "Convicted"]
  step %[I should see "How old were you when you got convicted?"]
  step %[I choose "18 or over"]
  step %[I should see "When were you convicted?"]
  step %[I enter a valid date]
  step %[I should see "What type of conviction did you get?"]
  step %[I choose "#{value}"]
end

When(/^I enter a valid date$/) do
  step %[I fill in "Day" with "1"]
  step %[I fill in "Month" with "1"]
  step %[I fill in "Year" with "1999"]
  step %[I click the "Continue" button]
end

When(/^I enter the following date (\d+)\-(\d+)\-(\d+)$/) do |day, month, year|
  step %[I fill in "Day" with "#{day}"]
  step %[I fill in "Month" with "#{month}"]
  step %[I fill in "Year" with "#{year}"]
  step %[I click the "Continue" button]
end

When(/^The current date is (\d+)\-(\d+)\-(\d+)$/) do |day, month, year|
  travel_to Date.new(year, month, day)
end

When(/^I have started a check$/) do
  step %[I visit "/"]
end

When(/^I am in the conviction known date step$/) do
  step %[I am completing a basic under 18 "Discharge" conviction]
  step %[I choose "Bind over"]
end
