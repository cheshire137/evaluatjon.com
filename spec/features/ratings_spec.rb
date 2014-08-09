require 'rails_helper'

feature 'ratings', js: true do
  context 'when not authenticated' do
    scenario 'visit ratings' do
      visit '/'
      expect(page).to have_text('evaluatjon')
    end
  end
end
