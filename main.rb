#!/usr/bin/ruby
['socket', 'cgi', 'json', 'cgi/util', 'shellwords', 'uri'].each(&method(:require))

port = ENV['PORT']
meths = ["html", "shell", "path"]
server = TCPServer.new port
#######################################################################################
def parseurl(head)
	req = head.split
	uri = URI(req[1])
	return CGI::parse(uri.query)
end

def sendreq(code, client, body)
	begin
		body = JSON.generate(body)
	rescue
		body = '{"ok": false, "message": "Internal Server Error"}'
	end
	head = "HTTP/1.1 #{code}\r\n"
	head += "Content-Length: #{body.size}\r\n"
	head += "Content-Type: application/json\r\n"
	head += "\r\n"
	head += "#{body}\r\n"
    client.print(head)
end


#######################################################################################

loop {
	client = server.accept
	Thread.start do
		begin
			request = client.readpartial(3000)
			params = parseurl(request)
			func = params["method"][0]
			data = params["data"][0]
			if func == nil or data == nil or !meths.include?(func)
				sendreq(400, client, {"ok": false, "message": "Bad Request"})
				client.close
			end
			if func == "html"
				dataencoded = CGI.escapeHTML(data)
				sendreq(200, client, {"ok": true, "data": dataencoded})
				client.close
			elsif func == "path"
				dataencoded = data.gsub!(/\.+/, ".")
				sendreq(200, client, {"ok": true, "data": dataencoded})
				client.close
			elsif func == "shell"
				dataencoded = data.shellescape
				sendreq(200, client, {"ok": true, "data": dataencoded})
				client.close
			end
	    rescue
			sendreq(500, client, {"ok":false, "message": "Internal Server Error"})
		ensure
			client.close
		end
	end
}
