guard 'motion' do
  watch(%r{^spec/.+_spec\.rb$})

  # RubyMotion App example
  watch(%r{^app/(.+)\.rb$})     { |m| "./spec/#{m[1]}_spec.rb" }
end