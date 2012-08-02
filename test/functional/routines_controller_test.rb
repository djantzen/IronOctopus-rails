require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase

    test "fetch the 1.0 JSON representation of sallys routines" do
      params = { :user_id => 'sally_the_client', :format => 'json', :version => 1.0 }
  
      get :index, params
  
      routines = JSON.parse(@response.body)
      sallys_push_pull_upper = routines[0]
      sallys_whole_body_mix = routines[1]
      assert_equal 'Push Pull Upper', sallys_push_pull_upper['name']
      assert_equal 'Whole Body Mix', sallys_whole_body_mix['name']      
    end

    test "fetch the 2.0 JSON representation of sallys routines" do
      params = { :user_id => 'sally_the_client', :format => 'json', :version => 2.0 }

      get :index, params

      response = JSON.parse(@response.body)
      assert_equal 'Unsupported API version: 2.0', response["message"]
    end


    test "normalize a new routine for sally" do
      controller = RoutinesController.new
      params = {
        :trainer => 'bob_the_trainer',
        :client => 'sally_the_client',
        :name => 'Leg Blaster',
        :goal => 'Blast yer gams!',
        :activity_sets => [
          {
            :count => 2,
            :activity => 'Back Squat',
            :repetitions => 12,
            :resistance => 90
          },
          {
            :count => 1,
            :activity => 'Hamstring Curl',
            :repetitions => 12,
            :resistance => 40
          }
        ]
      }
      routine = controller.normalize_routine(Routine.new, params)
      assert_equal 'Leg Blaster', routine.name
      assert_equal 3, routine.activity_sets.length
    end
#      post :create, params.to_json
 
    
end
