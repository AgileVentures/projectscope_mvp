class EncryptConfigOptionsAndRawSampleData < ActiveRecord::Migration
  def change
    rename_column :configs, :options, :encrypted_options
    rename_column :metric_samples, :raw_data, :encrypted_raw_data
  end
end
