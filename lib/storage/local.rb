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

    def full_path(location, origin = false)
      origin ? "#{@params[:uploaded_path]}/#{location}" : "#{@params[:base_path]}/#{location}"
    end

    private
      def copy(location, destination)
        FileUtils.mkpath(File.dirname(destination))
        FileUtils.cp(location, destination)
      end
  end
end
