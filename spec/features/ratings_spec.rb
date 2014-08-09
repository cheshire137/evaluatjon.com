require 'rails_helper'
require_relative '../../app/controllers/ratings_controller'

feature 'ratings', js: true do
  let(:user) { create(:user) }

  scenario 'add rating, sign in, reply, delete reply, delete rating' do
    visit '/'
    expect(page).to have_text('evaluatjon')

    # Select rating
    fill_ng 'new_rating.dimension', with: 'cleanliness'
    fill_ng 'new_rating.rater', with: 'Mr. Clean'
    fill_ng 'new_rating.comment', with: 'I love it!'
    find('.star-rating.mutable li:nth-child(3)').click
    expect(page).to have_css('.star-rating.mutable li:nth-child(1).filled')
    expect(page).to have_css('.star-rating.mutable li:nth-child(2).filled')
    last_star = page.find('.star-rating.mutable li:nth-child(3)')
    unless last_star.has_css?('.filled')
      expect(page).to have_css('.star-rating.mutable li:nth-child(3).half')
    end

    # Clear stars
    find('.star-rating.mutable .close').click
    expect(page).to_not have_css('.star-rating.mutable li.filled')
    expect(page).to_not have_css('.star-rating.mutable li.half')

    # Save rating
    find('.star-rating.mutable li:nth-child(3)').click
    click_button 'Rate Jon'
    expect(page).to have_text('cleanliness - Mr. Clean')
    expect(page).to have_css('.help-block', text: 'I love it!')
    expect(page).to have_css('.star-rating.pull-right li:nth-child(1).filled')
    expect(page).to have_css('.star-rating.pull-right li:nth-child(2).filled')
    last_star = page.find('.star-rating.pull-right li:nth-child(3)')
    unless last_star.has_css?('.filled')
      expect(page).to have_css('.star-rating.pull-right li:nth-child(3).half')
    end

    <<-END
    # Sign in
    expect(page).to_not have_text("You are signed in as #{user.email}.")
    fill_ng 'credentials.email', with: user.email
    fill_ng 'credentials.password', with: 'password'
    click_button 'Sign In'
    expect(page).to have_text("You are signed in as #{user.email}.")

    # Add reply
    page.find('.rating-footer .reply-link').click
    fill_ng 'new_reply.message', with: 'Taco love.'
    click_button 'Reply'
    expect(page).to have_css('.reply', text: 'Taco love.')

    # Click delete for reply, cancel delete
    page.find('.reply button.close').click
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_css('.reply', text: 'Taco love.')

    # Click delete for reply, confirm delete
    page.find('.reply button.close').click
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_css('.reply')

    # Click delete for rating, cancel delete
    page.find('.rating-footer .delete-rating-link').click
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_text('cleanliness - Mr. Clean')
    expect(page).to have_css('.help-block', text: 'I love it!')

    # Click delete for rating, confirm delete
    page.find('.rating-footer .delete-rating-link').click
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_text('cleanliness - Mr. Clean')
    expect(page).to_not have_css('.help-block', text: 'I love it!')
    END
  end
end
