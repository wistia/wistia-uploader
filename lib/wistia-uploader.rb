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

    self.post_file_to_wistia('', params, file)
  end


  def self.post_file_to_wistia(path, data, file, timeout=nil)
    data.reject! { |k,v| v.nil? || v.to_s.empty? } # Sanitize the params hash.

    Thread.new do
      Thread.current[:progress] = 0.0
      Thread.current[:last_pos] = 0

      uri = URI(UPLOAD_URL + path)
      http_client = self.get_http_client(uri, timeout)
      response = self.perform_http_post(file, data, uri, http_client)

      self.set_thread_status_from_response(response)
    end
  end


  private

  def self.perform_http_post(file, data, uri, http_client)
    if self.file_is_local?(file)
      self.upload_local_file(file, data, uri, http_client)
    else
      self.import_remote_file(file, data, uri, http_client)
    end
  end


  def self.get_http_client(uri, timeout)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if (uri.scheme == 'https')

    # Set the connection timeouts, if specified
    if timeout
      http.ssl_timeout = 10
      http.open_timeout = 10
      http.read_timeout = 10
    end

    http
  end


  def self.upload_local_file(file, data, uri, http)
    media = WFile.open(file)
    media.set_thread(Thread.current)
    req = Net::HTTP::Post::Multipart.new uri.request_uri, data.merge({
      'file' => UploadIO.new(media, 'application/octet-stream', File.basename(file))
    })
    media.close
    http.request(req)
  end


  def self.import_remote_file(file, data, uri, http)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(data.merge(url: file))
    http.request(req)
  end


  def self.file_is_local?(file_path)
    !self.file_is_remote?(file_path)
  end


  def self.file_is_remote?(file_path)
    file_path =~ /^(http|https|ftp):\/\//
  end


  def self.set_thread_status_from_response(response)
    Thread.current[:code] = response.code
    Thread.current[:body] = response.body

    Thread.current[:upload_status] = (response.code == '200') ? :success : :failed
  end
end
