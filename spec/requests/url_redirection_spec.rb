require 'spec_helper'

describe 'URL Redirecton' do
  context 'with no valid URL' do
    it 'shows a 404 error' do
      visit '/abcdef'
      page.should have_content I18n.t(:url_not_found)
    end
  end
end
