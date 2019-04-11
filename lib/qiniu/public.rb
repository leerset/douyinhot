class Qiniu::Public
  QINIU_UPLOAD_URL = 'http://upload.qiniu.com/'.freeze
  # PRIVATE_DOMAIN = 'pfr0mgju9.bkt.clouddn.com'
  PUBLIC_DOMAIN = 'qiniu.cece5.com'.freeze
  PUBLIC_BUCKET = 'cecejia'.freeze

  def self.generate_uptoken(key)
    put_policy = Qiniu::Auth::PutPolicy.new(PUBLIC_BUCKET, nil)
    put_policy.save_key = key
    Qiniu::Auth.generate_uptoken(put_policy)
  end

  def self.download_url(key)
    Qiniu::Auth.authorize_download_url_2(PUBLIC_DOMAIN, key)
  end

  def self.download_url2(key)
    primitive_url = "http://#{PUBLIC_DOMAIN}/#{key}"
    Qiniu::Auth.authorize_download_url(primitive_url)
  end

  def self.format_url(key, format = :p2w800h600)
    fop = case format
    when :p2w1024h768
      'imageView2/2/w/1024/h/768'
    when :p2w800h600
      'imageView2/2/w/800/h/600'
    when :p2w400h300
      'imageView2/2/w/400/h/300'
    when :p2w200h150
      'imageView2/2/w/200/h/150'
    when :p2w100h75
      'imageView2/2/w/100/h/75'
    when :p2w40h30
      'imageView2/2/w/40/h/30'
    else
      'imageView2/2/w/800/h/600'
    end
    Qiniu::Auth.authorize_download_url_2(PUBLIC_DOMAIN, key, {fop: fop})
  end

  def self.upload(key, filePath)
    put_policy = Qiniu::Auth::PutPolicy.new(PUBLIC_BUCKET, nil)
    put_policy.save_key = key
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    # Call upload_with_token_2 method to upload
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
      uptoken,
      filePath,
      key,
      nil,
      bucket: PUBLIC_BUCKET
    )
  end

end
