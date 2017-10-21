# == Schema Information
#
# Table name: configs
#
#  id                   :integer          not null, primary key
#  project_id           :integer
#  metric_name          :string
#  encrypted_options    :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_options_iv :string
#

require 'rails_helper'

describe Config do
  describe 'when created' do
    before(:each) do ; @p = create(:project) ; end
    it 'saves config options as hash' do
      @p.configs.create!(metric_name: 'xyz', metrics_params: 'test_metric', token: 'value')
      expect(@p.reload.configs.length).to eq 1
    end
  end
end