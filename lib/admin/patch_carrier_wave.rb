module CarrierWave
  module Uploader
    module Download
      class RemoteFile
        def original_filename
          # If it's coming through proxied_pages we need to get the proxied url, otherwise the filename is "proxied_pages"
          if file.base_uri.to_s =~ /proxied_pages/
            URI.parse(file.base_uri.query.split("=")[1]).path
          else
            File.basename(file.base_uri.path)
          end
        end
      end
    end
  end
end