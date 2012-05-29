module Storage

  class AwsS3 < Storage::Base
    def initialize(params)
      super(params)
      require 'aws/s3'
      ::AWS::S3::Base.establish_connection!(
        :access_key_id     => params[:access_key_id],
        :secret_access_key => params[:secret_access_key]
      )
    end

    def download(location, destination)
      file = ::AWS::S3::S3Object.value location, @params[:bucket]
      File.open(destination, "wb") do |new_file|
        new_file.write(file)
      end
    end

    def upload(location, destination)
      ::AWS::S3::S3Object.store(destination, open(location), @params[:bucket], :access => :public_read)
    end

    def delete(location)
      ::AWS::S3::S3Object.delete(location, @params[:bucket])
    end

    def update(location, destination)
      delete(destination)
      copy(location, destination)
    end

    def file_exist?(location)
      ::AWS::S3::S3Object.exists? location, @params[:bucket]
    end
  end
end
