require 'rails_helper'
require 'faraday'
require 'webmock/rspec'
require 'json'

RSpec.describe IterationsController, type: :controller do
  before(:each) do
    @iteration = create(:iteration)
    @github_task = create(:task, :github, iteration_id: @iteration.id)
    @local_task = create(:task, :local, iteration_id: @iteration.id)
    @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    @CM_task = create(:task, :preliminary, iteration_id: @iteration.id, title: 'Customer Meeting')

  end
  describe 'show task graph' do
    it "should get the all tasks iteration have" do
      expect(Task.where(iteration_id: @iteration.id)).to include @github_task
      expect(Task.where(iteration_id: @iteration.id)).to include @local_task
      expect(Task.where(iteration_id: @iteration.id)).to include @pivotal_task
    end
  end

  describe 'update all send request'do
    it "identify all task that are not finished" do
      skip
    end



    it "send iteration id and time_stamp to event" do
      # work when the request is able to be sent
      # todo
      # request = Faraday.new(url: '/events') do
      #  request.request :url_encoded
      # end
      skip
      uri = URI('https://api.api_specify_by_events_in_the_future')

      response = Net::HTTP.get(uri)

      expect(response).to be_an_instance_of(String)
    end
  end

  let(:event_request) { Faraday::Adapter::Test::Stubs.new() }

  describe 'event call back update task graph' do
    # stub the name of the http response from event
    before(:each) do
      response_hash = {:event_update => "Stub working", :time_stamp => "12324", "Customer Meeting"=>"true"}
      stub_request(:get, /api.projects_scope_events.com/).
          with(headers: {'Accept'=>'*/*',
                         'Host'=>'api.projects_scope_events.com',
                         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                         'User-Agent'=>'Faraday v0.12.2',
                         'User-Agent'=>'Ruby',
          }).
          to_return(status: 200, body: JSON[response_hash], headers: {:content_type => 'json'})
      @url = 'https://api.projects_scope_events.com'
    end

    it "get response from the stub events api" do
      uri = URI('https://api.projects_scope_events.com/update_event')
      response = Net::HTTP.get(uri)
      response_hash = JSON.parse(response)
      expect(response_hash["event_update"]).to eq("Stub working")
    end

    it "get response through farady gem" do
      skip
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 200, body: "some data")
      )
      graph_update_request = Faraday.new(url:'https://api.projects_scope_events.com')
      response = graph_update_request.get '/update_event'
      response_hash = JSON.parse(response.body)
      expect(response_hash["event_update"]).to eq("Stub working")
    end

    it "handle error events api authorization" do
      uri = URI('https://api.projects_scope_events.com/update_event')
      response = Net::HTTP.get(uri)
      response_hash = JSON.parse(response)
      expect(@iteration.update_task_graph response_hash).not_to be_nil
    end

    it "iterate through all the unfinished task and parse them with return new events" do
      uri = URI('https://api.projects_scope_events.com/update_event')
      response = Net::HTTP.get(uri)
      response_hash = JSON.parse(response)
      @iteration.update_task_graph response_hash
      task = Task.find_by_title('Customer Meeting')
      expect(task.task_status).to eq('finished')
    end

    it "send task to update if they are parsed in" do
      skip
    end

    it "update task if they reach requirement" do
      skip
    end

  end

  describe 'task reset' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end




end
