# encoding: utf-8
module Mjbook
  class ReceiptUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :fog

  def store_dir
    "uploads/receipts/#{model.user.company_id}/#{model.user_id}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [1000, 1000]  

  # Create different versions of your uploaded files:
   version :thumb do
     process :resize_to_limit => [100,100]
   end

   def extension_white_list
     %w(jpg jpeg gif png pdf)
   end

  end
end