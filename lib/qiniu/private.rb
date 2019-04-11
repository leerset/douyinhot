class Qiniu::Private
  QINIU_UPLOAD_URL = 'http://upload.qiniu.com/'.freeze
  # PRIVATE_DOMAIN = 'pfr0mgju9.bkt.clouddn.com'
  PRIVATE_DOMAIN = 'qiniu.cece5.com'.freeze
  PRIVATE_BUCKET = 'cecejia'.freeze

  def self.generate_uptoken(key)
    put_policy = Qiniu::Auth::PutPolicy.new(PRIVATE_BUCKET, nil)
    put_policy.save_key = key
    Qiniu::Auth.generate_uptoken(put_policy)
  end

  def self.download_url(key)
    Qiniu::Auth.authorize_download_url_2(PRIVATE_DOMAIN, key)
  end

  def self.format_url(key, format = :p2w800h600)
    fop = case format
    when :p2w1024h768
      'imageView2/2/w/1024/h/768'
    when :p2w800h600
      'imageView2/2/w/800/h/600'
    when :p2w400h300
      'imageView2/2/w/400/h/300'
    else
      'imageView2/2/w/800/h/600'
    end
    Qiniu::Auth.authorize_download_url_2(PRIVATE_DOMAIN, key, {fop: fop})
  end

  def self.upload(key, filePath)
    put_policy = Qiniu::Auth::PutPolicy.new(PRIVATE_BUCKET, nil)
    put_policy.save_key = key
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    # Call upload_with_token_2 method to upload
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
      uptoken,
      filePath,
      key,
      nil,
      bucket: PRIVATE_BUCKET
    )
  end

end
