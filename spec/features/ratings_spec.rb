require 'rails_helper'

feature 'ratings', js: true do
  context 'when not authenticated' do
    scenario 'add rating' do
      visit '/'
      expect(page).to have_text('evaluatjon')
      find('input[ng-model="new_rating.dimension"]').set 'cleanliness'
      find('input[ng-model="new_rating.rater"]').set 'Mr. Clean'
      find('input[ng-model="new_rating.comment"]').set 'I love it!'
      find('.star-rating.mutable li:nth-child(3)').click
      expect(page).to have_css('.star-rating.mutable li:nth-child(1).filled')
      expect(page).to have_css('.star-rating.mutable li:nth-child(2).filled')
      expect(page).to have_css('.star-rating.mutable li:nth-child(3).filled')
      click_button 'Rate Jon'
      expect(page).to have_text('cleanliness - Mr. Clean')
      expect(page).to have_css('.help-block', text: 'I love it!')
    end
  end
end
