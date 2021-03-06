require 'sinatra'
require 'active_record'

set :environment, :production

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Public < ActiveRecord::Base
end

def calc(year,month,date)
  if month < 3 then
    year -= 1
    month += 12
  end
  h = year + (year / 4).floor - (year / 100).floor + (year / 400).floor + ((13*month + 8)/5).floor + date
  case h % 7
  when 0
    s = "Sunday"
  when 1
    s = "Monday"
  when 2
    s = "Tuesday"
  when 3
    s = "Wednesday"
  when 4
    s = "Thursday"
  when 5
    s = "Friday"
  when 6
    s = "Saturday"
  end
end

def date(year,month)
  maxday = 0
  case month
  when 1, 3, 5, 7, 8, 10, 12
    maxday = 31
  when 4, 6, 9, 11
    maxday = 30
  when 2
    maxday = if (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))
               29
             else
               28
             end
  end
  i = 1
  puts maxday
  if maxday == 0
    puts "bad day"
  end
  day = Public.where(month: month)
  for n in day
    puts n.name
  end
  ary = Array.new()
  while i <= maxday
    s = calc(year,month,i)
    for n in day
      if n.kata == "date" then
        if n.date == i then
          if s != "Sunday" then
            s = "Public"
          end
        end
      else
        if n.week == i / 8 + 1 then
          if s != "Sunday" then
            s = "Public"
          end
      end
    end
    ary.push(s)
    i += 1
  end
  return ary
end
               
get '/' do
  @year = 2001
  @h = 9
  @h = date(2001,9)
  erb :calendar
end

get '/:year/:month' do
  @year = params[:year].to_i
  @month = params[:month].to_i
  if(@year < 0 || @month > 12 || @month < 1)
    @message = "Maybe parameter is bad"
  end
  @h = date(@year,@month)
  erb :calendar
end
