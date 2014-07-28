module Notes
  FactoryGirl.define do
    factory Note.singular_sym, class: Note do
      title  { Faker::Lorem.sentence }
    end
  end
end