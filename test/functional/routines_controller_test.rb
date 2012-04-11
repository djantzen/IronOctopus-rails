require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase
    include LogUtils
  
    test "fetch the JSON representation of sallys push pull upper routine" do
      params = { :user_id => 'sally_the_client', :format => 'json' }
  
      get :index, params
  
      routines = JSON.parse(@response.body)
      sallys_push_pull_upper = routines[0]
      
      assert_equal 'Push Pull Upper', sallys_push_pull_upper['name']
    end
    
    test "normalize a new routine for sally" do
      controller = RoutinesController.new
      params = {
        :trainer => 'bob_the_trainer',
        :client => 'sally_the_client',
        :owner => 'sally_the_client',
        :name => 'Leg Blaster',
        :goal => 'Blast yer gams!',
        :activity_sets => [
          {
            :activity => 'Back Squat',
            :repetitions => 12,
            :resistance => 90
          },
          {
            :activity => 'Hamstring Curl',
            :repetitions => 12,
            :resistance => 40
          }
        ]
      }
      routine = controller.normalize_routine(params)
      assert_equal 'Leg Blaster', routine.name
      assert_equal 2, routine.activity_sets.length
    end
#      post :create, params.to_json
 
    
end
