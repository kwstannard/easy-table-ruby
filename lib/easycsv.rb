Dir[File.join(File.dirname(__FILE__), 'easycsv', '*.rb')].each do |file|
  require 'easycsv/' + File.basename(file, '.rb')
end
