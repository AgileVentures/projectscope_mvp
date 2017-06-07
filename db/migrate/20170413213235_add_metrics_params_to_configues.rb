class AddMetricsParamsToConfigues < ActiveRecord::Migration
  def change
    add_column :configs, :metrics_params, :string
    add_column :configs, :token, :string
  end
end
