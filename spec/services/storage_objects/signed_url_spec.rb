# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::SignedUrl do
  include ActiveSupport::Testing::TimeHelpers

  let(:committed) { create(:storage_object, :committed) }
  let(:pending_object) { create(:storage_object) }

  describe 'download' do
    it 'round-trips a committed object' do
      token = described_class.encode_download(committed).token
      expect(described_class.decode_download(token)).to eq(committed)
    end

    it 'expires after 5 minutes and reports the expiry' do
      signed = nil
      freeze_time do
        signed = described_class.encode_download(committed)
        expect(signed.expires_at).to eq(5.minutes.from_now)
      end

      travel(5.minutes + 1.second) { expect(described_class.decode_download(signed.token)).to be_nil }
    end

    it 'does not resolve a pending object' do
      expect(described_class.decode_download(described_class.encode_download(pending_object).token)).to be_nil
    end

    it 'rejects a tampered, blank or non-string token' do
      expect(described_class.decode_download("#{described_class.encode_download(committed).token}x")).to be_nil
      expect(described_class.decode_download(nil)).to be_nil
      expect(described_class.decode_download('')).to be_nil
      expect(described_class.decode_download({ a: 1 })).to be_nil
    end
  end

  describe 'upload' do
    it 'round-trips a pending object' do
      token = described_class.encode_upload(pending_object).token
      expect(described_class.decode_upload(token)).to eq(pending_object)
    end

    it 'expires after 15 minutes and reports the expiry' do
      signed = nil
      freeze_time do
        signed = described_class.encode_upload(pending_object)
        expect(signed.expires_at).to eq(15.minutes.from_now)
      end

      travel(14.minutes) { expect(described_class.decode_upload(signed.token)).to eq(pending_object) }
      travel(15.minutes + 1.second) { expect(described_class.decode_upload(signed.token)).to be_nil }
    end

    it 'does not resolve a committed object' do
      expect(described_class.decode_upload(described_class.encode_upload(committed).token)).to be_nil
    end

    it 'rejects a tampered token' do
      expect(described_class.decode_upload("#{described_class.encode_upload(pending_object).token}x")).to be_nil
    end
  end

  it 'does not accept a token of one purpose for the other' do
    upload_token = described_class.encode_upload(pending_object).token
    download_token = described_class.encode_download(committed).token

    expect(described_class.decode_download(upload_token)).to be_nil
    expect(described_class.decode_upload(download_token)).to be_nil
  end

  describe 'urls' do
    it 'builds absolute urls from the configured external url' do
      allow(Sagittarius::Configuration).to receive(:file_storage_external_url).and_return('https://files.example.com')

      expect(described_class.upload_url('a+b')).to eq('https://files.example.com/storage_objects/upload?signature=a%2Bb')
      expect(described_class.download_url('abc')).to eq('https://files.example.com/storage_objects/download?signature=abc')
    end

    it 'defaults to the local gateway' do
      expect(described_class.upload_url('abc')).to eq('http://localhost:8080/storage_objects/upload?signature=abc')
    end
  end
end
