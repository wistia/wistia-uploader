require 'net/http'
require 'net/http/post/multipart'

UPLOAD_URL = "https://upload.wistia.com/"

class WistiaUploader

  def self.upload_media(api_pass, project, file, name=nil, contact=nil)
    params = { :api_password => api_pass, :project_id => project }
    params[:contact_id] = contact if contact
    params[:name] = name if name

    code, body = self.post_file_to_wistia('', params, file)
    return body
  end
  
  def self.post_file_to_wistia(path, data, file, timeout=nil)
    uri = URI(UPLOAD_URL + path)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if (uri.scheme == 'https')

    # Set the connection timeouts, if specified
    if timeout
      http.ssl_timeout = 10
      http.open_timeout = 10
      http.read_timeout = 10
    end

    media = File.open(file)
    req = Net::HTTP::Post::Multipart.new uri.request_uri, data.merge({
      'file' => UploadIO.new(media, 'application/octet-stream', File.basename(file))
    })
    res = http.request(req)
    media.close

    return [res.code, res.body]
  end

end
