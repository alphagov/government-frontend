require 'rest-client'
require 'parallel'

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


  Parallel.each(wraith['paths'], in_processes: 2) do |path_name,path|
    response_types = get_paths(path_name, path, wraith['domains'])
    response_codes = response_types.map do |response_type|
      response_type[:code]
    end
    same_response_codes = response_codes.uniq.length == 1
    unless same_response_codes
      abort("failed on #{path_name} " + response_types.to_s )
    end
  end
  puts 'all response codes match'

end

