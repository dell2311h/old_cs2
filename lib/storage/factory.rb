module Storage
  class Factory
    def self.initialize_storage provider
      raise "Unknown storage" unless Pandrino.storages[provider]
      require "storage/#{provider.to_s}"
      storage = "Storage::#{provider.to_s.camelize}".constantize
      storage.new(Pandrino.storages[provider])
    end
  end
end