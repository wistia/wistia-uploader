require 'spec_helper'

describe WistiaUploader do
  describe 'class methods' do
    describe '#upload_media' do
      it 'posts the specified file to Wistia when given optional params' do
        password = mock('password')
        project = mock('project')
        file = mock('file')
        name = mock('name')
        contact = mock('contact')

        WistiaUploader.should_receive(:post_file_to_wistia).with('',
          hash_including({
            api_password: password,
            project_id: project,
            contact_id: contact,
            name: name,
          }), file
        )
        WistiaUploader.upload_media(password, project, file, name, contact)
      end
      it 'posts the specified file to Wistia when given only required params' do
        password = mock('password')
        project = mock('project')
        file = mock('file')

        WistiaUploader.should_receive(:post_file_to_wistia).with('',
          hash_including({
            api_password: password,
            project_id: project,
          }), file
        )
        WistiaUploader.upload_media(password, project, file)
      end
    end
    describe '#post_file_to_wistia' do
      describe 'given a local file' do
        it 'uploads the file' do
          file = mock('file')
          file.stub :set_thread
          WFile.should_receive(:open).with('/var/tmp/dummy.mov').and_return(file)

          upload_io = mock('upload io')
          UploadIO.should_receive(:new).and_return(upload_io)

          request = mock('request')
          Net::HTTP::Post::Multipart.should_receive(:new).and_return(request)

          http = mock('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=

          response = mock('response')
          http.should_receive(:request).and_return(response)
          file.stub :close

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')

          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, '/var/tmp/dummy.mov')
          thread.join
        end
      end
      describe 'given a web file' do
        it 'imports the file' do
          request = mock('request')
          Net::HTTP::Post.should_receive(:new).and_return(request)
          request.stub :set_form_data

          http = mock('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=

          response = mock('response')
          http.should_receive(:request).and_return(response)

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')

          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'http://fakedomain.cc/dummy.mov')
          thread.join
        end
      end
      describe 'given an ssl web file' do
        it 'imports the file' do
          request = mock('request')
          Net::HTTP::Post.should_receive(:new).and_return(request)
          request.stub :set_form_data

          http = mock('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=

          response = mock('response')
          http.should_receive(:request).and_return(response)

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')

          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'https://fakedomain.cc/dummy.mov')
          thread.join
        end
      end
      describe 'given an ftp file' do
        it 'imports the file' do
          request = mock('request')
          Net::HTTP::Post.should_receive(:new).and_return(request)
          request.stub :set_form_data

          http = mock('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=

          response = mock('response')
          http.should_receive(:request).and_return(response)

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')

          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'ftp://fakedomain.cc/dummy.mov')
          thread.join
        end
      end
    end
  end
end
