module Notes
  RSpec.describe FrontendApp, js: true, type: :feature do
    context 'Use local api' do
      before(:each) do
        visit '/'
        unless find(:id, 'use-local').checked?
          find(:id, 'use-local').set(true)
        end
      end

      describe 'homepage' do
        it 'displays index page' do
          expect(title).to eql 'Notes API UI'
          expect(page).to have_content 'Your Notes'
          expect(page).to have_selector(:id, 'create-note-btn')
          expect(find(:id, 'create-note-btn')).to be_visible
          expect(page).to have_selector(:id, 'refresh-btn')
          expect(find(:id, 'refresh-btn')).to be_visible
        end

        it 'has no table and rows within' do
          expect(page).to_not have_xpath('//table/tbody/tr')
        end
      end

      describe 'create feature' do
        it 'invalid if title empty' do
          # Go to Create note form
          find(:id, 'create-note-btn').click
          expect(page).to have_content 'Create new note'

          # note.id is empty and not shown
          expect(page).to_not have_selector(:id, 'static-id-group')

          # Check for invalid state
          expect(find_field('input-title').value).to be_empty
          expect(page).to have_selector(:xpath, "//div[@id='input-title-group'][contains(@class, 'has-error')]")
          expect(page).to have_content 'Title is required'
          expect(page).to have_selector(:xpath, "//input[@id='submit-btn'][@disabled]")
        end

        it 'created if title not empty' do
          # Go to Create note form
          find(:id, 'create-note-btn').click

          # Fill title
          fake_title = Faker::Lorem.sentence
          fill_in('title', with: fake_title)

          # Check for valid state
          expect(find_field('input-title').value).to_not be_empty
          expect(page).to_not have_selector(:xpath, "//div[@id='input-title-group'][contains(@class, 'has-error')]")
          expect(page).to_not have_content 'Title is required'
          expect(page).to_not have_selector(:xpath, "//input[@id='submit-btn'][@disabled]")

          # Submit and check exists
          find(:id, 'submit-btn').click
          expect(page).to have_content 'Note created'
          expect(page).to have_content fake_title
          expect(page).to have_xpath('//table/tbody/tr', count: 1)
        end
      end

      describe 'edit feature' do
        it 'should be update note' do
          # Create note using helper
          fake_title = Faker::Lorem.sentence
          create_note(fake_title)

          # Go to edit
          find(:xpath, '//td/a').click
          expect(page).to have_content 'Edit your note'
          expect(page).to have_selector(:id, 'static-id-group')
          new_fake_title = Faker::Lorem.sentence
          fill_in('title', with: new_fake_title)

          # Submit and check exists
          find(:id, 'submit-btn').click
          expect(page).to have_content 'Note saved'
          expect(page).to have_content new_fake_title
          expect(page).to have_xpath('//table/tbody/tr', count: 1)

          # TODO. Check that id the same
        end
      end

      describe 'delete feature' do
        it 'from list' do
          # Create note using helper
          create_note(Faker::Lorem.sentence)

          # Check exists of Delete button
          expect(page).to have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']")

          # Click them
          find(:xpath, ("//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']")).click

          # Check exists of Abort deletion and Confirm buttons, and not exists Delele button
          expect(page).to_not have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']")
          expect(page).to have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Confirm']")
          expect(page).to have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Abort deletion']")

          # Click Abort deletion - should come back Delete button
          find(:xpath, "//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Abort deletion']").click
          expect(page).to have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']")
          expect(page).to_not have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Confirm']")
          expect(page).to_not have_xpath("//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Abort deletion']")

          # Click again Delete and then Confirm - should have Note deleted notice and empty table
          find(:xpath, "//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']").click
          find(:xpath, "//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Confirm']").click
          expect(page).to have_content 'Note deleted'
          expect(page).to_not have_xpath('//table/tbody/tr')
        end

        it 'from edit form' do
          # Create note using helper
          create_note(Faker::Lorem.sentence)
          expect(page).to have_xpath('//table/tbody/tr', count: 1)

          # Go to edit
          find(:xpath, '//td/a').click

          # Click Delete and then Confirm - should have Note deleted notice and empty table
          find(:xpath, "//div[contains(@class, 'deleteConfirmation')]/div/button[text()=' Delete']").click
          find(:xpath, "//div[contains(@class, 'deleteConfirmation')]/div/button[text()='Confirm']").click
          expect(page).to have_content 'Note deleted'
          expect(page).to_not have_xpath('//table/tbody/tr')
        end
      end

      describe 'refresh feature' do
        it 'create note from outside UI' do
          # Create note using helper
          create_note(Faker::Lorem.sentence)
          expect(page).to have_xpath('//table/tbody/tr', count: 1)

          # Create note using factory_girl
          create(Note.singular_sym)

          # Click Refresh and check count of notes - should be 2
          find(:id, 'refresh-btn').click
          expect(page).to have_xpath('//table/tbody/tr', count: 2)
        end
      end

      describe 'orderBy Created at feature' do
        it 'should change the order to opposite' do
          # Create note using helper
          create_note(Faker::Lorem.sentence)
          create_note(Faker::Lorem.sentence)
          expect(page).to have_xpath('//table/tbody/tr', count: 2)

          start_order = page.all(:xpath, '//td/a').map(&:text)

          find(:id, 'toggle-order').click

          expect(page.all(:xpath, '//td/a').map(&:text)).to eql start_order.reverse
        end
      end
    end
  end
end