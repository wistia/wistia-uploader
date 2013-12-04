require 'spec_helper'

describe WistiaUploader do
  describe 'public class methods' do
    describe '#upload_media' do
      it 'posts the specified file to Wistia when given optional params' do
        password = double('password')
        project = double('project')
        file = double('file')
        name = double('name')
        contact = double('contact')

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
        password = double('password')
        project = double('project')
        file = double('file')

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
          file = double('file')
          file.stub :set_thread
          WFile.should_receive(:open).with('/var/tmp/dummy.mov').and_return(file)

          upload_io = double('upload io')
          UploadIO.should_receive(:new).and_return(upload_io)

          request = double('request')
          Net::HTTP::Post::Multipart.should_receive(:new).and_return(request)

          http = double('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=
          http.stub :verify_mode=

          response = double('response')
          http.should_receive(:request).and_return(response)
          file.stub :close

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')

          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, '/var/tmp/dummy.mov')
          thread.join
        end
      end
      describe 'for remote files' do
        before do
          request = double('request')
          Net::HTTP::Post.should_receive(:new).and_return(request)
          request.stub :set_form_data

          http = double('net_http')
          Net::HTTP.should_receive(:new).and_return(http)

          http.stub :use_ssl=
          http.stub :verify_mode=

          response = double('response')
          http.should_receive(:request).and_return(response)

          response.should_receive(:code).exactly(2).and_return('200')
          response.should_receive(:body).and_return('OK')
        end
        it 'web file: imports the file' do
          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'http://fakedomain.cc/dummy.mov')
          thread.join
        end
        it 'ssl web file: imports the file' do
          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'https://fakedomain.cc/dummy.mov')
          thread.join
        end
        it 'ftp file: imports the file' do
          thread = WistiaUploader.post_file_to_wistia('', {api_password: 'pass', project_id: 5}, 'ftp://fakedomain.cc/dummy.mov')
          thread.join
        end
      end
    end
  end

  describe 'private class methods' do
    describe '#perform_http_post' do
      describe 'with local file' do
        it 'performs upload' do
          WistiaUploader.stub(:file_is_local?).and_return(true)
          WistiaUploader.should_receive(:upload_local_file).exactly(1)
          WistiaUploader.send :perform_http_post, nil, nil, nil, nil
        end
      end
      describe 'with remote file' do
        it 'performs import' do
          WistiaUploader.stub(:file_is_local?).and_return(false)
          WistiaUploader.should_receive(:import_remote_file).exactly(1)
          WistiaUploader.send :perform_http_post, nil, nil, nil, nil
        end
      end
    end
    describe '#file_is_local? and #file_is_remote?' do
      it 'works for http (non-ssl) files' do
        file_path = 'http://example.com/movie.mov'
        WistiaUploader.send(:file_is_local?, file_path).should be_false
        WistiaUploader.send(:file_is_remote?, file_path).should be_true
      end
      it 'works for http (ssl) files' do
        file_path = 'https://example.com/movie.mov'
        WistiaUploader.send(:file_is_local?, file_path).should be_false
        WistiaUploader.send(:file_is_remote?, file_path).should be_true
      end
      it 'works for ftp files' do
        file_path = 'ftp://example.com/movie.mov'
        WistiaUploader.send(:file_is_local?, file_path).should be_false
        WistiaUploader.send(:file_is_remote?, file_path).should be_true
      end
      it 'works for local files' do
        file_path = '/var/www/movie.mov'
        WistiaUploader.send(:file_is_local?, file_path).should be_true
        WistiaUploader.send(:file_is_remote?, file_path).should be_false
      end
    end
  end
end
