module Notes
  module CapybaraHelpers
    def create_note(title)
      visit '/'
      find(:id, 'create-note-btn').click
      fill_in('title', with: title)
      find(:id, 'submit-btn').click
    end
  end
end