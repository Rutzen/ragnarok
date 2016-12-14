require 'whois-parser'

wh = Whois.whois("organicadigital.com")
org = wh.parser



hash = {
	:quem => org.domain.to_s,
	:vencimento => org.expires_on.to_s
}

File.open("vencimento_org", 'w') { |file| file.write(puts "#{hash[:quem] +"  vence em:  "+ hash[:vencimento]}") }

