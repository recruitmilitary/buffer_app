require 'spec_helper'

describe BufferApp::ResponseParser do

  describe '.parse' do
    context 'when success is true' do
      it 'returns the original response' do
        response = { 'success' => true, 'message' => 'hi' }

        BufferApp::ResponseParser.parse(response).should == response
      end

      context 'when the message indicates an error' do
        it 'raises an exception' do
          BufferApp::ResponseParser::ERROR_MESSAGES.each do |(message, error)|
            expect {
              BufferApp::ResponseParser.parse('success' => true, 'message' => message)
            }.to raise_error error
          end
        end
      end
    end

    context 'when success if false' do
      context 'when there is a code' do
        context 'when the code is known' do
          it 'raises the error associated with the code' do
            expect {
              BufferApp::ResponseParser.parse('success' => false, 'code' => 1030, 'message' => 'Whoops')
            }.to raise_error BufferApp::BadRequest, 'Whoops'
          end
        end

        context 'when the code is unknown' do
          it 'raises a generic API error with the code and message' do
            expect {
              BufferApp::ResponseParser.parse('success' => false, 'code' => 42, 'message' => 'Whoops')
            }.to raise_error BufferApp::APIError, "Unknown error code: 42\nMessage: Whoops"
          end
        end
      end
    end

    context 'when the response has an error' do
      it 'raises an error with the message' do
        response = { 'error' => "The provided access token is invalid" }

        expect {
          BufferApp::ResponseParser.parse(response)
        }.to raise_error BufferApp::Unauthorized, response['error']
      end
    end
  end

end
