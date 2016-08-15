class EncryptConfigOptionsAndRawSampleData < ActiveRecord::Migration
  def change
    rename_column :configs, :options, :encrypted_options
    add_column    :configs, :encrypted_options_iv, :string
    rename_column :metric_samples, :raw_data, :encrypted_raw_data
    add_column    :metric_samples, :encrypted_raw_data_iv, :string
  end
end
