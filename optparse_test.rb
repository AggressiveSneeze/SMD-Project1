require 'optparse'

options = {:name => nil, :age => nil}

parser = OptionParser.new do|opts|
	opts.banner = "Usage: years.rb [options]"
	opts.on('-n', '--name name', 'Name') do |name|
		options[:name] = name;
	end

	opts.on('-a', '--age age', 'Age') do |age|
		options[:age] = age;
	end

	opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end

parser.parse!

if options[:name] == nil
	print 'Enter Name: '
    options[:name] = gets.chomp
end

if options[:age] == nil
	print 'Enter Age: '
    options[:age] = gets.chomp
end

sayHello = 'Hello ' + options[:name] + ', '

if Integer(options[:age]) == 100
    sayAge = 'You are already 100 years old!'
elsif Integer(options[:age]) < 100
    sayAge = 'You will be 100 in ' + String(100 - Integer(options[:age])) + ' years!'
else
    sayAge = 'You turned 100 ' + String(Integer(options[:age]) - 100) + ' years ago!'
end

puts sayHello + sayAge