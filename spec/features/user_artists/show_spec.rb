# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'artist show page' do
  before(:each) do
    @user = GoogleUser.new({ id: 1, attributes: { email: 'test@test.com' } })
    @artist = Artist.new('tiki', 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe 'display' do
    it 'shows header' do
      VCR.use_cassette('artist_show') do
        visit user_artist_path(@user.id, @artist.id)

        within('#header') do
          expect(page).to have_content(@artist.username)
        end
      end
    end
  end

  describe 'link to upload page' do
    it 'can redirect to art_pieces upload page' do
      # As a user, when I click the link to upload an image, I am directed to the image upload page where I can click to upload an image file, add tags and a name to the image, click upload to add image.
      # Route to upload (create) page
      # Add options to upload image (file drag and drop and/or file directory upload)
      # Add Upload or save button
      # Redirect to artist show page after upload complete
      visit user_artist_path(@user.id, @artist.id)

      # Change to have_button with image source for icon
      expect(page).to have_link('Upload an Art Piece')

      click_link 'Upload an Art Piece'

      expect(current_path).to eq(new_user_artist_art_piece_path(@user.id, @artist.id))
      expect(page).to have_content('Upload an Art Piece')
      expect(page).to have_content('Name Your New Art Piece:')
      expect(page).to have_content('Describe Your Art Piece:')
      expect(page).to have_field(:art_piece_title)
      expect(page).to have_button('Create Art Piece')
    end
  end
end
