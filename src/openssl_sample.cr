require "option_parser"
require "openssl"
# Command line tool for encrypting and decrypting 
module OpensslSample
  VERSION = "0.1.0"
  extend self

  data="Very CONFIDENTIAL data"
  key= "RANDOM1400vat2412armAMDbobomiz44"
  iv="rtyu2000tpk43320"
  enc = 0
  OptionParser.parse do |parser|

      parser.on "-k KEY" , "decrypt data" do |k|
          key = k
      end
      parser.on "-i IV" , "decrypt data" do |i|
          iv = i
      end
      parser.on "-d DATA" , "decrypt data" do |d|
          enc = -1
          data = d
      end
      parser.on "-e DATA" , "encrypt data" do |d|
          enc = 1
          data = d
      end

  end


  def encrypt(data, key, iv)
      cipher = OpenSSL::Cipher.new "aes-256-cbc"
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv
      encrypted_data = IO::Memory.new
      encrypted_data.write cipher.update(data)
      encrypted_data.write cipher.final
      en = Base64.urlsafe_encode(encrypted_data)
      {en , key,iv}
  end

  def decrypt(data, key, iv)
      decipher = OpenSSL::Cipher.new "aes-256-cbc"
      decipher.decrypt
      decipher.key = key
      decipher.iv = iv
      dec_data = IO::Memory.new
      dec_data.write decipher.update(data)
      dec_data.write decipher.final
      dec_data.to_s
  end
  if enc == 1   
      en = encrypt(data,key,iv)
      output = en
  elsif enc == -1
      output = decrypt(Base64.decode(data),key,iv)
  end
  puts output
end
