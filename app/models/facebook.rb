class Facebook < ActiveRecord::Base
  
  belongs_to :user
  
  def profile
    @profile ||= FbGraph::User.me(self.access_token).fetch
  end

  class << self
    extend ActiveSupport::Memoizable

    def config
      @config ||= if ENV['fb_client_id'] && ENV['fb_client_secret'] && ENV['fb_scope']
        {
          :client_id     => ENV['fb_client_id'],
          :client_secret => ENV['fb_client_secret'],
          :scope         => ENV['fb_scope']
        }
      else
        YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
      end
    rescue Errno::ENOENT => e
      raise StandardError.new("config/facebook.yml could not be loaded.")
    end

    def app
      FbGraph::Application.new config[:client_id], :secret => config[:client_secret]
    end

    def auth(redirect_uri = nil)
      FbGraph::Auth.new config[:client_id], config[:client_secret], :redirect_uri => redirect_uri
    end

    def identify(fb_user)

      _fb_user_ = find_or_initialize_by_identifier(fb_user.identifier.try(:to_s))
      _fb_user_.access_token = fb_user.access_token.access_token
      _fb_user_.save!
      fb_current_user=_fb_user_.profile
    
      if _fb_user_.user.nil?                                                            # first time login user   
        _user_ = User.new          
        _user_.email   =fb_current_user.email        
        _user_.save!  
        
        _fb_user_.username=fb_current_user.username 
        _user_.facebook=_fb_user_
        _user_.icon_from_url('https://graph.facebook.com/'+fb_user.identifier.try(:to_s)+'/picture?&type=large')
        _user_.save!              
      end  
         _fb_user_  #return  
   
    end
  end

end
