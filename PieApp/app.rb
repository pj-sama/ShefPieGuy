require 'simplecov'
SimpleCov.start
require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-twitter'
require 'twitter'
require 'json'
require 'rubygems'
require 'erb'
require_relative 'front_end'
require_relative './rb/database/user'
require_relative './rb/database/row'
require_relative './rb/database/user_offer'
require_relative './rb/database/offer'
require_relative './rb/database/pie'
require_relative './rb/database/order'
require_relative './rb/database/pie_order'
require_relative './rb/database/admin'
require_relative 'twitter_actions'

set :bind, '0.0.0.0'
include ERB::Util

configure do
    enable :sessions
end

use OmniAuth::Builder do
    provider :twitter, 'XY2D6vBwiOVkOROIj76sORXhU', 'mBW1bEDvfDOqXxWoUdc59Qoe5Mxu3JtjqQyJBFJ4vp2E8qcDpV'
end

get '/callback' do
    erb :callback
end

post '/register' do
    # Add the data to the database
    @uid = session[:user]
    @postcode = params[:postcode]
    @housenum = params[:housenum]
    @additional = params[:additional]

    if ( Actions.location(@postcode)!= "unknown" )
        @goodpostcode = true
        if ( !User.exists(@uid) )
            #Inserts UID and data if it doesnt exist
            User.insert(@uid,@postcode,@housenum,@additional)
        else
            #Updates values if UID already exists
            User.update_postcode(@postcode,@uid)
            User.update_house_no(@housenum,@uid)
            User.update_add_info(@additional,@uid)
        end
        redirect to("/user")
    else
        @goodpostcode = false
        redirect to("/update")
    end
end

post '/doAdminLogin' do
    @success = Admin.username_and_password_correct?(params[:admin], params[:password])
    if (@success)
        session[:admin] = true
        redirect to('/admin')
    else
        redirect to('/adminauthfail')
    end
end

get '/auth/twitter/callback' do
    session[:user] = env['omniauth.auth']['uid']
    redirect to("/loggedin")
end

get '/loggedin' do
    @uid = session[:user]
    @exists = User.exists(@uid)
    if (@exists)
        #If there are missing entries
        @error = !User.check_postcode(@uid) || !User.check_house_no(@uid)
    end
    @registered = @exists && !@error #If the user is registered and there are no errors.
    if (@registered)
        redirect to("/user")
    else
        erb :register
    end
end


post '/submitorder' do
    unless (session[:admin]==true)
        redirect to("adminlogin")
    end
    ordersArray = []
    params.keys.each do |k|
        unless(k=="captures")
            ordersArray.push(k)
            ordersArray.push(params[k])
        end
    end
    ordersArray.shift()
    Order.insert(ordersArray.first().to_s,0,Actions.location(Row.select("User","Postcode",["UserID"],ordersArray.first()).first.first.to_s),0)
    orderId = Row.select("'Order'","OrderNo",["UserID"],ordersArray.shift().to_s).last.first
    orderPrice = 0
    while (ordersArray.length>0)
        if (ordersArray[1] != 0)
            pieId = ordersArray.shift()
            quantity = ordersArray.shift()
            PieOrder.insert("#{orderId}",pieId,quantity)
            orderPrice += (Row.select("Pie","Price",["PieID"],pieId).first.first*quantity.to_i)
        else
            ordersArray.shift()
            ordersArray.shift()
        end
    end
    Order.update_loc_total(orderPrice,orderId)
    tweetorder = Tweet.select_all().first.first
    Tweet.delete(tweetorder)
    redirect to("/adminhandle")
end

post '/addoffers' do
    # Obtain all the values from the form
    @multi = params[:multiplier]
    @desc = params[:description]
    @apply = params[:applyTo]
    # Checking who to apply it to
    if (@apply == "All")
        @global = "t"
    else
        @global = "f"
    end
    Offer.insert(@multi, @desc, @global)
    @offerID = Offer.select_all().last[0]
    if (@global=="f")
        UserOffer.insert(@apply, @offerID)
    end
    redirect to("adminoffers")
end

get '/deleteoffer/:offer' do
    unless (session[:admin]==false)
        @offerID = params['offer'].to_i
        unless(@offerID.nil?)
            Offer.delete(@offerID)
        end
    end
    redirect to("adminoffers")
end

get '/deleteuser/:user' do
    unless (session[:admin]==false)
        @userID = params['user'].to_s
        unless(@userID.nil?)
            User.delete(@userID)
        end
    end
    redirect to("accounts")
end

post '/updateadmin' do
    @who = params[:adminID]
    @username = params[:username]
    @pwd = params[:password]
    @pwdC = params[:passwordC]
    @confirm = "f"
    if(@pwd==""||@pwdC=="")
        @confirm = "f"
        puts "Passwords are blank"
    else
        if (@pwd==@pwdC)
            puts "Passwords match"
            @confirm = "t"
        else
            puts "Passwords don't match"
            @confirm = "f"
        end
    end
    if (@who=="New")
        if(@username!=""&&@confirm=="t"||!(Admin.exists(@username)))
            puts "Create new Admin"
            Admin.insert(@username,@pwd)
        end
    else
        if(@username!=""||!(Admin.exists(@username)))
            puts "Update username"
            Admin.update_username(@username,@who.to_i)
        end
        if(@confirm=="t")
            puts "Update password"
            Admin.update_password(@password,@who.to_i)
        end
    end
    redirect to("accounts")
end

get '/deleteadmin/:admin' do
    @admin = params['admin'].to_i
    Admin.delete(@admin)
    redirect to("accounts")
end

get '/deleteme' do
    User.delete(session[:user])
    @loginstatus = "justdeleted"
    session[:admin] = nil
    session[:user] = nil
    erb :home
end

post '/editoffer' do
    if (session[:admin]==false)
        redirect to("adminlogin")
    end
    @userID = params[:userID]
    @offerID = params[:offerID]
    unless (UserOffer.exists(@userID,@offerID))
        UserOffer.insert(@userID,@offerID)
    end
    redirect to("adminoffers")
end

post '/addpie' do
    # Obtain all the values from the form
    @add_pie_name = params[:add_pie_name]
    @add_pie_description = params[:add_pie_description]
    @add_pie_price = params[:add_pie_price]
    @add_pie_picture = ""
    Pie.insert(@add_pie_name, @add_pie_description, @add_pie_price, @add_pie_picture)
    redirect to("adminpies")
end

get '/deletepie/:pid' do
    unless (session[:admin]==false)
        @delete_pie_id = params['pid'].to_i
        unless(@delete_pie_id.nil?)
            Pie.delete(@delete_pie_id)
        end
    end
    redirect to("adminpies")
end

post '/updatepie' do
    # Obtain all the values from the form
    @update_pie_id = params[:update_pie_id]
    @update_pie_name = params[:update_pie_name]
    @update_pie_description = params[:update_pie_description]
    @update_pie_price = params[:update_pie_price]
    @update_pie_picture = ""
    unless(@update_pie_id.nil?)
      Pie.update_name(@update_pie_name, @update_pie_id)
      Pie.update_description(@update_pie_description, @update_pie_id)
      Pie.update_price(@update_pie_price, @update_pie_id)
      Pie.update_picture(@update_pie_picture, @update_pie_id)
    end
    redirect to("adminpies")
end

post '/editflag/:orderID' do
    orderID = params['orderID'].to_i
    flagID = params['flagID'].to_i
    Order.update_flag_id(flagID,orderID)
    redirect to('admin')
end