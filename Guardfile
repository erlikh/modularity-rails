# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{spec/javascripts/.+})
  watch(%r{vendor/assets/javascripts/.+})
  # Rails Assets Pipeline
  # watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
end
