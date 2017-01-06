require 'whois-parser'
require 'active_support/core_ext/string/conversions'
require 'net/smtp'

counter = 0
@array = []
@vencimentos = []

@ragnarok = {}

# inserts domains line by line into the empty array
File.open("domains_string.txt", "r") do |infile|
    infile.each_line do |line|
    	@array <<  " #{line}"
        counter = counter + 1
    end
end	

#creates the variable with the output file to be manipulated properly
file = File.open("vencimento", 'w')


#good_item makes string proper for further use by taking away spaces and linebreaks
#parses items in the array and inserts the info into the hash
@array.each do |item|
	good_item = item.gsub("\s","").gsub("\r\n","")
	ready = Whois.whois(good_item).parser
	hash = {
		quem: good_item,
		vencimento: ready.expires_on.to_s
	}
	file.write("#{hash[:quem] +"  vence em:  "+ hash[:vencimento] + "\n"}")
end


@array.each do |item|
	good_item = item.gsub("\s","").gsub("\r\n","")
	ready = Whois.whois(good_item).parser
	if ready.expires_on.nil?
		next
	end
		hash = {
		quem: good_item,
		vencimento: ready.expires_on
		}
		agora = DateTime.now
		vencimento = hash[:vencimento].to_datetime
			require 'pry'; binding.pry;
			if vencimento < agora
				@ragnarok = item
			end	
		end
		
@ragnarok.each do |item|
		require 'pry'; binding.pry;
	message = <<MESSAGE_END
	De: Pietro Rutzen <pietro.rutzen@organicadigital.com>
	Para: A Test User <emaildocliente@todomain.com>,<emailxikaos@
	Assunto: Seu domínio está próximo da data de vencimento!
	Olá!

	Tudo certo?

	Gostaria de lembrar que é importante que seja feita a renovação de seu domínio!
	
	MESSAGE_END

	Net::SMTP.start('localhost') do |smtp|
		smtp.send_message message, 
		'pietro.rutzen@organicadigital.com',
		item.admin_contacts.to_s
	end
end


puts "llamas and lions"






#@array.each do |item|
#	good_item = item.gsub("\s","").gsub("\r\n","")
#	ready = Whois.whois(good_item).parser
#	@vencimentos = ready.expires_on.to_s
#end
