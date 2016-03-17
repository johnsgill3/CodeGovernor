module WebhookHelper
    def self.verify_signature(key, payload_body, gh_signature)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), key, payload_body)
        return render(status: :bad_request, plain: "Signatures didn't match!") \
            unless Rack::Utils.secure_compare(signature, gh_signature)
    end

    def self.pr_opened(payload)
    end

    def self.pr_synchronized(payload)
    end

    def self.pr_closed(payload)
    end

    def self.pr_reopened(payload)
    end

    def self.issue_comment(payload)
    end

    def self.ping(payload)
    end
end
