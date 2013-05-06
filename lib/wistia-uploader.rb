# Setup environment via bundler
require 'bundler/setup'

require 'net/http'
require 'net/http/post/multipart'

UPLOAD_URL = 'https://upload.wistia.com/'

# Hacktacular mostly-accurate patch for upload monitoring.
class WFile < File
  def set_thread(thread)
    @thread = thread
  end
  def read(*args)
    if @thread
      @thread[:progress] = ((1.0 * self.pos()) / self.size()).round(2)
      @thread[:last_pos] = self.pos()
    end
    super(*args)
  end
end


class WistiaUploader

  def self.upload_media(api_pass, project, file, name=nil, contact=nil)
    params = { :api_password => api_pass, :project_id => project }
    params[:contact_id] = contact if contact
    params[:name] = name if name

    return self.post_file_to_wistia('', params, file)
  end
  
  def self.post_file_to_wistia(path, data, file, timeout=nil)
    Thread.new do
      thread = Thread.current
      thread[:progress] = 0.0
      thread[:last_pos] = 0

      uri = URI(UPLOAD_URL + path)

      # Sanitize the params hash.
      data.reject! { |k,v| (v == nil) || v.empty? }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if (uri.scheme == 'https')

      # Set the connection timeouts, if specified
      if timeout
        http.ssl_timeout = 10
        http.open_timeout = 10
        http.read_timeout = 10
      end

      media = WFile.open(file)
      media.set_thread(thread)

      req = Net::HTTP::Post::Multipart.new uri.request_uri, data.merge({
        'file' => UploadIO.new(media, 'application/octet-stream', File.basename(file))
      })
      res = http.request(req)
      media.close

      thread[:code] = res.code
      thread[:body] = res.body

      if res.code == '200'
        thread[:upload_status] = :success
      else
        thread[:upload_status] = :failed
      end
    end
  end

end
