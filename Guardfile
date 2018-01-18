guard :shell do
  watch /(app|lib)\/.*/ do |m|
    puts `cd spec/dummy; bundle exec rails restart`
    m[0] + " has changed."
  end
end
