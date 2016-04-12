Given(/^the (right|wrong) wsdl url is being used/) do |arg|
  if arg == "right"
    ENV['TEST_WSDL'] = "http://localhost:#{ENV['MOCK_SERVER_PORT']}/index.php?wsdl"
  elsif arg == "wrong"
    raise "not implemented (yet)"
  else
    raise "that's funny - how did we get " + arg + "?"
  end
end

Given(/^the suds wsdl cache is cleared$/) do
  `example/virtualenv/bin/clear-suds-cache #{ENV['TEST_WSDL']} 2>&1`
  expect($?.exitstatus).to be(0)
end

Given(/^the station input "([^"]*)"$/) do |station_code|
  @station_code = station_code
end

Given(/^the (right|wrong) api key is set/) do |arg|
  if arg == "right"
    ENV['DARWIN_WEBSERVICE_API_KEY'] = "FAKE-API-KEY"
  elsif arg == "wrong"
    ENV['DARWIN_WEBSERVICE_API_KEY'] = "WRONG-API-KEY"
  else
    raise "that's funny - how did we get " + arg + "?"
  end
end

When(/^the command line tool is run$/) do
  #TODO: figure out how to check the first thing that is output, and then answer - couldn't get it working with popen3
  @output = `echo #{@station_code} | example/virtualenv/bin/python example/test-example.py 2>&1`
  @exit_status = $?.exitstatus
end

Then(/^the program (should|shouldn't) succeed$/) do |arg|
  expect(@exit_status).send(to_or_not_to(arg), be(0))
end

Then(/^the output (should|shouldn't) contain expected departure$/) do |arg|
  expect(@output).send(to_or_not_to(arg), include("Hogwarts"))
  expect(@output).send(to_or_not_to(arg), include("11:00"))
  expect(@output).send(to_or_not_to(arg), include("9 3/4"))
end

Then(/^the output (should|shouldn't) contain board message$/) do |arg|
  expect(@output).send(to_or_not_to(arg), include("humour"))
end

Then(/^the output (should|shouldn't) contain bad key error$/) do |arg|
  expect(@output).send(to_or_not_to(arg), include("Unauthorized"))
end

Then(/^the output (should|shouldn't) contain bad media type error$/) do |arg|
  expect(@output).send(to_or_not_to(arg), include("bad media type"))
end


def to_or_not_to(should_or_should_not)
  return "to" if should_or_should_not == "should"
  return "not_to" if should_or_should_not == "shouldn't"
  raise "only accepts should or shouldn't but got " + arg
end


Given(/^prepare correct request$/) do
  sampleXMLPath = File.expand_path('../sample-request-from-wiki.xml', __FILE__)
  @payload = File.open(sampleXMLPath, 'rb') { |f| f.read }

  #our wsdl is not exactly like theirs, so the raw requests come out different:
  @payload.gsub! 'GetDepartureBoardRequest', 'GetDepartureBoard'

  #our test server only works with Kings Cross
  @payload.gsub! 'MAN', 'KGX'

  #our test server only works with Kings Cross
  @payload.gsub! '*** YOUR TOKEN GOES HERE ***', 'FAKE-API-KEY'

end

Given(/^use (wrong|correct) header$/) do |rightOrWrong|
  if rightOrWrong != "wrong"
    @content_type = "text/xml"
  else
    @content_type = "application/xml"
  end

end

Given(/^send$/) do
  http = Net::HTTP.new("localhost", ENV['MOCK_SERVER_PORT'])
  request = Net::HTTP::Post.new("/index.php")
  request.set_content_type(@content_type)
  request.body = @payload
  response = http.request(request)
  @output = response.body
  @status = response.code
end

Then(/^we should get a "([^"]*)"$/) do |expectedStatus|
  expect(@status).to eq(expectedStatus)
end

Given(/^change api key$/) do
  @payload.gsub! 'FAKE-API-KEY', 'WRONG-API-KEY'
end

Given(/^change station code$/) do
  @payload.gsub! 'KGX', "XXX"
end
