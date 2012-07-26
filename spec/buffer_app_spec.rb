require 'spec_helper'

describe BufferApp do

  let(:valid_options) {
    {
      :profile_id => ENV['BUFFER_PROFILE_ID'],
      :access_token => ENV['BUFFER_ACCESS_TOKEN'],
    }
  }

  let(:buffer) {
    BufferApp.new valid_options
  }

  let(:unauthorized) {
    BufferApp.new valid_options.merge :profile_id => nil, :access_token => nil
  }

  shared_examples_for 'unauthorized' do
    it 'raises an error' do
      expect {
        buffer.find_update update_id
      }.to raise_error BufferApp::Unauthorized
    end
  end

  it 'raises an error when missing access_token' do
    expect {
      BufferApp.new valid_options.except :access_token
    }.to raise_error ArgumentError
  end

  it 'raises an error when missing profile_id' do
    expect {
      BufferApp.new valid_options.except :profile_id
    }.to raise_error ArgumentError
  end

  describe '#create_update' do
    context 'when not authorized' do
      use_vcr_cassette 'create unauthorized'

      it 'raises an unauthorized error' do
        expect {
          unauthorized.create_update 'doesnotmatter'
        }.to raise_error BufferApp::Unauthorized
      end
    end

    context 'when authorized' do
      context 'when successful' do
        use_vcr_cassette 'create authorized and successful', :match_requests_on => [:method, :uri]

        it 'returns an update' do
          update_text = "stuff and junk #{Time.now.to_i}"
          update = buffer.create_update update_text

          update.text.should =~ /stuff and junk/
          update.due_at.should be_an_instance_of Time
          update.id.should_not be_nil
        end
      end

      context 'when not successful' do
        it 'raises an error'
      end
    end
  end

  describe '#find_update' do
    context 'when not authorized' do
      use_vcr_cassette 'find unauthorized'

      it 'raises an unauthorized error' do
        pending 'this is raising connection refused error'

        expect {
          unauthorized.find_update 'doesnotmatter'
        }.to raise_error BufferApp::Unauthorized
      end
    end

    context 'when authorized' do
      context 'when successful' do
        use_vcr_cassette 'find authorized and successful', :match_requests_on => [:method, :uri]

        it 'returns an update' do
          created = buffer.create_update "hello world #{Time.now.to_i}"
          found = buffer.find_update created.id

          found.id.should == created.id
          found.text.should == created.text
          found.due_at.should == created.due_at
        end
      end

      context 'when not found' do
        use_vcr_cassette 'find authorized and not found', :match_requests_on => [:method, :uri]

        it 'raises an error' do
          pending 'this is raising connection refused error'

          expect {
            buffer.find_update '500fe966a45f0f0360000056'
          }.to raise_error BufferApp::NotFound
        end
      end
    end
  end

end
