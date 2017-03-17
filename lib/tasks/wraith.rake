require 'rest-client'
require 'parallel'
require 'colorize'

desc "check response codes"
task :wraith_check_codes, [:arg1] do |t, args|
  wraith = YAML::load(File.open('test/wraith/' + args[:arg1]))

  def request_url(domain, path)
    url = domain + path
    begin
      response = RestClient::Request.execute(method: :get, url: url, max_redirects: 0)
      response_code = { domain: domain, code: response.code }
    rescue RestClient::ExceptionWithResponse => e
      response_code = { domain: domain, code: e.response.code }
    end
    response_code
  end

  def get_paths(path_name, path, domains)
    puts "checking #{path_name} #{path}"
    Parallel.map(domains) do |domain_name,domain|
      request_url(domain, path)
    end
  end


  Parallel.each(wraith['paths'], in_processes: 2) do |path_name, path|
    response_types = get_paths(path_name, path, wraith['domains'])
    response_codes = response_types.map do |response_type|
      response_type[:code]
    end
    same_response_codes = response_codes.uniq.length == 1
    if same_response_codes
      code = response_codes.uniq.first
      text = "#{path_name} #{path} status: #{code}"
      if code == 200
        puts text.green
      else
        puts text.yellow
      end
    else
      abort("failed on #{path_name} " + response_types.to_s ).red
    end
  end
  puts "\n all response codes match".green
end

