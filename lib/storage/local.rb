module Storage
  class Local < Storage::Base
    def download(location, destination)
      copy(location, destination)
    end

    def upload(location, destination)
      copy(location, destination)
    end

    def delete(location)
      File.delete(location)
    end

    def update(location, destination)
      copy(location, destination)
    end

    def file_exist?(location)
      File.exist?(location)
    end

    def full_path(location, server_type)
      "#{@params[:base_path]}/#{server_type}/#{location}"
    end

    private
      def copy(location, destination)
        FileUtils.mkpath(File.dirname(destination))
        FileUtils.cp(location, destination)
      end
  end
end
