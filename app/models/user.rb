class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "2 eBooks<br/>valued at $14",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
        },
        {
            'count' => 10,
            "html" => "2 eBooks<br/>valued at $35",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
        },
        {
            'count' => 25,
            "html" => "5 eBooks + Set of<br/>3 Gift Cards valued at $50",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
        },
        {
            'count' => 50,
            "html" => "5 eBooks + Set of 7 Gift Cards + 1 PSYCH-K session with Cara Phillips",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
