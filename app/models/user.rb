class User < ApplicationRecord
    attr_reader :password
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: { message: 'Password can\'t be blank' }
    validates :password, length: { minimum: 6, allow_nil: true }
    after_initialize :ensure_session_token

    has_many :cats,
        primary_key: :id,
        foreign_key: :owner_id,
        class_name: :Cat

    has_many :rental_requests,
        primary_key: :id,
        foreign_key: :requester_id,
        class_name: :CatRentalRequest

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
        self.password_digest
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(user_name, password)
        user = User.find_by(username: user_name)
        return user if user && user.is_password?(password)
        nil
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end