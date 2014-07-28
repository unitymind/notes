module Notes
  RSpec.describe Note do
    subject { Note.singular_sym }

    context 'validate' do
      it { expect(build(subject)).to be_valid }

      describe 'presence_of :title' do
        context 'when title = \'\'' do
          it { expect(build(subject, title: '')).to_not be_valid }
        end

        context 'when title = nil' do
          it { expect(build(subject, title: nil)).to_not be_valid }
        end
      end
    end
  end
end