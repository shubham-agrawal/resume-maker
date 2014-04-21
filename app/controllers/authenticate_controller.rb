require 'rubygems'

require 'linkedin'

class AuthenticateController < ApplicationController

  def index
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new("752cqogua16ta5", "ZfzS2s2KTFJdgz04")
    request_token = client.request_token(:scope => "r_basicprofile+r_fullprofile+r_emailaddress+r_contactinfo", :oauth_callback =>
                                      "http://#{request.host_with_port}/authenticate/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def callback
    client = LinkedIn::Client.new("752cqogua16ta5", "ZfzS2s2KTFJdgz04")
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    
    @profile = client.profile(:fields => ['interests', 'certifications', 'email-address', 'main-address', 'phone-numbers', 'first-name', 'last-name', 'headline', 'positions', 'educations'])
    @phone = @profile.phone_numbers.all.first.phone_number
    @email = @profile.email_address
    @address = @profile.main_address
    @educations = @profile.educations.all
    @positions = @profile.positions.all
    @certifications = @profile.certificates
    @interests = @profile.interests

    html = render_to_string 
  	
  	new_record = Resume.new
    new_record.content = html
    new_record.save
    
    redirect_to "/editor/resumes/" + new_record.id.to_s
  end

  def logout
  	session.clear
  	redirect_to root_path
  end
end