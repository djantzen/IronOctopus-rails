require 'test_helper'

class WorkControllerTest < ActionController::TestCase
  include LogUtils
  test "post_a_valid_work_record" do
# assert_difference('Work.count') do              
    response = post(:create,
                { :format => "json", :user_id => "sally_the_client",
                  :_json => [{"start_time"=>"2012-06-30 14:39:14 -0700",
                              "position"=>"1.0", "routine"=>"Push Pull Upper", "repetitions"=>"10",
                              "end_time"=>"2012-06-30 14:39:14 -0700", "activity"=>"Bench Press",
                              "resistance"=>"135.0"}] })
    assert_response :success
    wtf? response.body

  end
    
  test "invalid_work_records_generate_error_response" do
         
  end
   
    
end
