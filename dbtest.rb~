require 'active_record'
require 'date'


ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Era < ActiveRecord::Base
end

a = Era.all
puts Date.parse(a[0].begin)
puts Date.parse(a[0].end)
puts Era.count
