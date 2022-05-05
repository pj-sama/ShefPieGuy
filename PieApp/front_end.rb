get '/' do
    erb :home
end
get '/home' do
    erb :home
end
get '/login' do
    redirect to("/auth/twitter")
    
end
get '/contact' do
    erb :contact
end
get '/adminlogin' do
    erb :adminlogin
end
get '/adminauthfail' do
    @failedadminauth = "true"
    erb :adminlogin
end
get '/about' do
    erb :about
end
get '/menu' do
    @pies = Pie.select_all
    erb :menu
end
get '/user' do
    @goodpostcode = true
    @error = false
    if (session[:user].nil?)
        erb :whoops
    else
        @users = User.select_all()
        @users.each do |u|
            if(u[0]==session[:user])
                @user = u
            end
        end
        erb :data
    end
end
get '/update' do
    if session[:user].nil?
        erb :whoops
    else
        erb :register
    end
end
get '/userupdate' do
    if session[:user].nil?
        erb :whoops
    else
        @update = true
        erb :register
    end
end
get '/auth/failure' do
    redirect to("/authfail")
end
get '/authfail' do
    @failedauthflow = "true"
    erb :home
end
get '/logout' do
    @loginstatus = "justloggedout"
    session[:admin] = nil
    session[:user] = nil
    erb :home
end
get '/updatedb' do
    if (session[:admin] == true)
        Actions.find_orders()
        print "*****"
        print "Database updated"
        print "*****"
        redirect to("/admin")
    else
        redirect to("adminlogin")
    end

end
get '/bestpublicity' do
    @val = "empty"
    if (session[:admin] == true)
        bestPub = Actions.best_publicity()
        @val = "Best publicity is: #{bestPub}"
        print "*****"
        print @val
        print "*****"
        @orders = Order.select_all()
        @pieorders = PieOrder.select_all()
        @pielist = Pie.select_all()
        @locations = Location.select_all()
        erb :adminconsole
    else
        redirect to("adminlogin")
    end
end
get '/hardreset' do
    if (session[:admin] == true)
        Actions.reset()
        redirect to("/admin")
    else
        redirect to("adminlogin")
    end
end
get '/addpublicity' do
    if (session[:admin] == true)
        Actions.add_publicity(params[:publicity])
        erb :adminconsole
    else
        redirect to("adminlogin")
    end

end
get '/admin' do
    @val = "empty"
    if (session[:admin] == true)
      @allorders = Order.select_all()
      @pieorders = PieOrder.select_all()
      @pielist = Pie.select_all()
      @locations = Location.select_all()
      @orders = []
      @allorders.each do |o|
          unless o[2]==5
              @orders.push(o)
          end
      end
      erb :adminconsole
    else
        redirect to("adminlogin")
    end
end

get '/adminoffers' do
    if (session[:admin] == true)
        @personal_offers = []
        @offers = Actions.global_offers()
        @alloffers = Offer.select_all()
        @users = User.select_all()
        @useroffers = UserOffer.select_all()
        @edit = "t"
        @useroffers.each do |uRow|
            current_id = uRow[1]
            current_offer = Offer.select_by_id(current_id)
            unless (@personal_offers.include? current_offer)
                @personal_offers.push(current_offer)
            end
        end
        erb :adminoffers
    else
        redirect('/adminlogin')
    end
end

get '/offers' do
    @offers = Actions.global_offers()
    unless session[:user].nil?
        @useroffers = Actions.personal_offers(session[:user])
        # Select all the actual orders relevant to the user
        @personal_offers = []
        @edit = "f"
        @useroffers.each do |uRow|
            current_id = uRow[1]
            current_offer = Offer.select_by_id(current_id)
            unless (@personal_offers.include? current_offer)
                @personal_offers.push(current_offer)
            end
        end
    end
    erb :offers
end

get '/adminpies' do
    if (session[:admin] == true)
        @pies = Pie.select_all
        @edit = "t"
        erb :adminpies
    else
        erb :notfound
    end
end

get '/adminhandle' do
    if (session[:admin] == true)
        @tweetorders = Tweet.select_all()
        @piemenu = Pie.select_all()
        #Adding functionality to display offers
        @offers = Actions.global_offers()
        unless session[:user].nil?
            @useroffers = Actions.personal_offers(session[:user])
            # Select all the actual orders relevant to the user
            @personal_offers = []
            @useroffers.each do |uRow|
                current_id = uRow[1]
                current_offer = Offer.select_by_id(current_id)
                unless (@personal_offers.include? current_offer)
                    @personal_offers.push(current_offer)
                end
            end
        end
        erb :adminhandle
    else
        redirect to("adminlogin")
    end
end

get '/accounts' do
    if (session[:admin] == true)
        users = User.select_all()
        @uid = []
        users.each do |u|
            @uid.push(u[0])
        end
        admins = Admin.select_all()
        @admin = []
        admins.each do |a|
            @admin.push([a[0],a[1]])
        end
        erb :accounts
    else
        redirect to("adminlogin")

    end
end

get '/data' do
    @users = User.select_all()
    @users.each do |u|
        if(u[0]==session[:user])
            @user = u
        end
    end
    erb :data
end

not_found do
    erb :notfound
end
error do
    erb :whoops
end
