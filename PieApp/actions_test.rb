require 'minitest/autorun'
require_relative 'twitter_actions'

class TestCase < Minitest::Test    
    def test_reset_twitter
        Actions.reset()
        assert_equal [], Tweet.select_all()
        assert_equal [], PromoTweet.select_all()
    end
    
    def test_recieved_publicity
        Actions.reset()
        assert_equal "There are no publicity tweets in the database", Actions.best_publicity()
        Actions.add_publicity("Testing publicity")
        assert_equal 1, PromoTweet.select_all().first.length
        assert_equal PromoTweet.select_all().first.first, Actions.best_publicity()
    end
    
    def test_id_to_tweet_text
        assert_equal "@SheffPieGuy Send me pies", Actions.id_to_tweet_text(971060395120168960)
        assert_equal "Star Wars Episode IX: Revenge of the #Covfefe", Actions.id_to_tweet_text(869846978024185857)
        assert_equal "Why do bluetooth devices randomly fall out with one another. Yesterday, keyboard, today it's the mouse. Can't we all just get along?", Actions.id_to_tweet_text(911144221951905793)
    end
    
    def test_id_to_user_id
        assert_equal 717494916692180992, Actions.id_to_user_id(971060395120168960)
        assert_equal 157218534, Actions.id_to_user_id(869846978024185857)
        assert_equal 70767861, Actions.id_to_user_id(911144221951905793)
    end
    
    def test_id_to_user_screen_name
        assert_equal "RiichardSomers", Actions.id_to_user_screen_name(971060395120168960)
        assert_equal "DeathStarPR", Actions.id_to_user_screen_name(869846978024185857)
        assert_equal "philmcminn", Actions.id_to_user_screen_name(911144221951905793)
    end
    
    def test_location
        Actions.reset()
        assert_equal 1, Actions.location("S3 7LG")
        assert_equal 2, Actions.location("LS3 7LG")
        assert_equal "unknown", Actions.location("LU3 7LG")
    end
end