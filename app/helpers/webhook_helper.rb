module WebhookHelper
    def self.verify_signature(key, payload_body, gh_signature)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), key, payload_body)
        Rack::Utils.secure_compare(signature, gh_signature)
    end

    def self.pr_opened(_payload)
    end

    def self.pr_synchronized(_payload)
    end

    def self.pr_closed(_payload)
    end

    def self.pr_reopened(_payload)
    end

    def self.issue_comment(_payload)
    end

    def self.ping(_payload)
    end
end
