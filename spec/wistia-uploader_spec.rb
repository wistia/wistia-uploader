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
  end
end
