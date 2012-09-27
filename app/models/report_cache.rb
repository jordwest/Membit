class ReportCache < ActiveRecord::Base
  attr_accessible :data, :key

  def self.store_data_with_key(key, data)
    entry = ReportCache.find_or_create_by_key(key)
    entry.data = ActiveSupport::JSON.encode(data)
    entry.save
  end

  def self.get_data_with_key(key)
    entry = ReportCache.find_by_key(key)
    return ActiveSupport::JSON.decode(entry.data)
  end
end
