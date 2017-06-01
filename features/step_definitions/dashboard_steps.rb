Then(/^I should see the dashboard$/) do
  expect(current_path).to eq(dashboard_path)
  expect(page).to have_content("Dashboard")
end
