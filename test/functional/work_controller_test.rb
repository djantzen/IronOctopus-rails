require 'test_helper'

class WorkControllerTest < ActionController::TestCase

  test "post_a_valid_work_record_via_html" do
    login_as(User.find_by_login('sally_the_client'))
    assert_difference('Work.count') do
      post(:create, {
            "user_id" => "sally_the_client",
            :routine => {
              :routine => "Push Pull Upper",
              :activity_sets => [{
                  "activity" => "Bench Press",
                  :start_time => "2012-06-30 14:39:14 -0700",
                  :end_time => "2012-06-30 14:39:14 -0700",
                  :position => "1.0",
                  'repetitions' => "10",
                  :resistance => "135.0"
                }]
            }
          })
    end
    assert_response :success
  end

  test "post_a_valid_work_record_via_json" do
    assert_difference('Work.count') do
      login_as(User.find_by_login('sally_the_client'))
      post(:create, {
              :format => "json", :user_id => "sally_the_client",
              :_json => [{:start_time => "2012-06-30 14:39:14 -0700",
                          "position" => "1.0",
                          'routine' => "Push Pull Upper",
                          :repetitions => "10",
                          "end_time" => "2012-06-30 14:39:14 -0700",
                          "activity" => "Bench Press",
                          "resistance" => "135.0"}] })
    end
    assert_response :success
  end

  test "invalid_work_records_generate_error_response" do
         
  end
   
    
end
