require 'whois-parser'
require 'active_support/core_ext/string/conversions'

counter = 0
@array = []
@clean = []
@ragnarok = []

#METHODS

#takes away spaces and linebreaks
def clean_line(line)
	line.gsub("\s","").gsub("\r\n","")
end

#parses item 
def parse(item)
	Whois.whois(item).parser
end

#expiration date of given parsed item
def expire(item)
	parse(item).expires_on
end

#reads every line on the txt and put info into array
File.open("domains_string.txt", "r") do |infile|
    infile.each_line do |line|
    	@array <<  " #{line}"
        counter = counter + 1
    end
end	


@array.each do |item|
	 limpo = clean_line(item)
	@clean << limpo
end

@clean.each_with_index do |item , index|
	if item.match(";")
		splitted = item.split(";")
		@clean[index] = nil
		@clean.compact!
		@clean = @clean + splitted
	end
end


@clean.each do |item|
	agora = DateTime.now
	vencimento = expire(item)
	if vencimento.nil?
		next
	end 
	if agora.to_date < vencimento.to_date
		days = vencimento.to_date - agora.to_date
			if days < 7/1
			   	@ragnarok << item 
			end
	end

end

#require 'pry'; binding.pry;
puts "oi"

