class Actions
    require 'twitter'
    require_relative './rb/database/user'
    require_relative './rb/database/promo_tweet'
    require_relative './rb/database/row'
    require_relative './rb/database/tweet'
    require_relative './rb/database/user_offer'
    require_relative './rb/database/offer'
    require_relative './rb/database/location'
    require_relative './rb/database/flag'
    
    config = {
    :consumer_key => 'XY2D6vBwiOVkOROIj76sORXhU',
    :consumer_secret => 'mBW1bEDvfDOqXxWoUdc59Qoe5Mxu3JtjqQyJBFJ4vp2E8qcDpV',
    :access_token => '927856963945488384-i0ExQqlAu6A8tRBO3Sz0HqcmwxhcWCQ',
    :access_token_secret => 'Wx39D8pJOYWAWam9I1qMDe8zDU9HR3dgJllDaeNTxKIXx'
    }
    $client = Twitter::REST::Client.new(config)
    
    #Takes tweet id and returns the text of the tweet
    #* *Args* :
    #  - Tweet id
    #* *Returns* :
    #  - Tweet text
    def self.id_to_tweet_text(tweet)
        return $client.status(tweet).text
    end
    
    #Takes tweet id and returns the id of the user which tweeted it
    #* *Args* :
    #  - Tweet id
    #* *Returns* :
    #  - Tweet user id
    def self.id_to_user_id(tweet)
        return $client.status(tweet).user.id
    end
    
    #Takes tweet id and returns the screen name of the user which tweeted it
    #* *Args* :
    #  - Tweet id
    #* *Returns* :
    #  - Tweet user screen name
    def self.id_to_user_screen_name(tweet)
        return $client.status(tweet).user.screen_name
    end
    
    #Takes user id and returns the screen name of that user
    #* *Args* :
    #  - User id
    #* *Returns* :
    #  - User screen name
    def self.uid_to_screen_name(uid)
        return $client.user(uid).screen_name
    end
    
    #Unlikes all tweets by the account, deletes tweets and empties Tweet and PromoTweet tables in DB
    def self.reset()
        liked = $client.favorites('sheffpieguy')
        liked.each do |tweet|
            $client.unfavorite(tweet)
        end
        
        tweeted = $client.user_timeline('SheffPieGuy')
        tweeted.each do |tweet|
            $client.destroy_tweet(tweet)
        end
        
        promo = PromoTweet.select_all()
        promoTweets = []
        promo.each do |row|
            promoTweets.push(row.first)
        end
        promoTweets.each do |tweet|
            PromoTweet.delete(tweet)
        end
        
        dbTweets = Tweet.select_all()
        seenTweets = []
        dbTweets.each do |row|
            seenTweets.push(row.first)
        end
        seenTweets.each do |tweet|
            Tweet.delete(tweet)
        end
    end
    
    #Find all mentions of the twitter account
    #Checks does not exist in the database and will ask them to sign up if not
    #Checks if existing account has valid address and asks to update it if not
    #Checks if tweet has not already been liked and puts tweet ids of orders in database
    #Likes all tweets it has seen
    def self.find_orders()
        mentions = $client.mentions_timeline(result_type: "recent", since_id: 970687499801686023)
        liked = $client.favorites('sheffpieguy')
        mentions.each do |tweet|
            if (!(User.exists(tweet.user.id)) && !(liked.include?(tweet)))
                $client.update("@#{tweet.user.screen_name} Please sign up at our website: PLACEHOLDER", in_reply_to_status_id: tweet.id)
                $client.favorite(tweet)
            elsif (!(liked.include?(tweet)) && (!User.check_postcode(tweet.user.id) || !User.check_house_no(tweet.user.id)))
                $client.update("@#{tweet.user.screen_name} Please add a delivery address", in_reply_to_status_id: tweet.id)
                $client.favorte(tweet)
            elsif !(liked.include?(tweet))
                $client.update("@#{tweet.user.screen_name} Thank you for your order", in_reply_to_status_id: tweet.id)
                $client.favorite(tweet)
                Tweet.insert(tweet.id)
            end
        end
    end
    
    #Checks each publicity tweet in the database and shows the most interacted with
    #* *Returns* :
    #  - the tweet id of the tweet with the most combined likes and retweets
    def self.best_publicity()
        promo = PromoTweet.select_all()
        if promo.length == 0
           return "There are no publicity tweets in the database" 
        end
        promoTweets = []
        promo.each do |row|
            promoTweets.push(row.first)
        end
        best = promoTweets.first
        promoTweets.each do |tweet|
            if ($client.status(tweet).retweet_count+$client.status(tweet).favorite_count)>
                    ($client.status(best).retweet_count+$client.status(best).favorite_count)
                best = tweet
            end
        end
        return best
    end
    
    #Tweets the text given and stores the tweet id in the database as a publicity tweet
    #* *Args* :
    #  - Text of the publicity tweet
    def self.add_publicity(text)
        $client.update(text)
        latest = $client.user_timeline('sheffpieguy').first
        PromoTweet.insert(latest.id)
    end
    
    #Takes tweet id and returns the location of the user
    #* *Args* :
    #  - Tweet id
    #* *Returns* :
    #  - 0 for Sheffield User, 1 for Leeds User, "unknown" for neither
    def self.location(postcode)
        if (/LS[0-9]/.match(postcode) && postcode[0,2] == "LS")
            return 0
        elsif (/S[0-9]/.match(postcode) && postcode[0,1] == "S")
            return 1
        else
            return "unknown"
        end
    end
    
    #Gets all of the personal offers relevant to the given UID
    #* *Args* :
    # - The user id of the user in question
    #* *Returns* :
    # - An array of offers relevant to the user
    def self.personal_offers(uid)
        offers = UserOffer.select_all()
        personal_offers = []
        offers.each do |offer|
            if (offer[0]==uid)
                personal_offers.push(offer)
            end
        end
        return personal_offers
    end
    
    #Gets all of the offers that are global and not personal
    #* *Returns*
    # - An array of offers that apply to everyone
    def self.global_offers()
        offers = Offer.select_all()
        global_offers = []
        offers.each do |offer|
            if (offer[3]=="t")
                global_offers.push(offer)
            end
        end
        return global_offers
    end
    
    #Returns the name of the flag with given id
    #* *Params*
    # - The id of the flag
    #* *Returns*
    # - The name of that flag
    def self.get_flag_name(i)
        case i
            when 0
                return "Recieved"
            when 1
                return "Needs Details"
            when 2
                return "Amend"
            when 3
                return "Processing"
            when 4
                return "Delivering"
            when 5
                return "Complete"
        end
    end
end