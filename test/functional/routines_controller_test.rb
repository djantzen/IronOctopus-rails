require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase

  test "fetch the 1.0 JSON representation of sallys routines" do
      login_as(User.find_by_login('sally_the_client'))

      params = { :user_id => 'sally_the_client', :format => 'json', :version => 1.0 }
  
      get :index, params
  
      routines = JSON.parse(@response.body)
      sallys_push_pull_upper = routines[0]
      sallys_whole_body_mix = routines[1]
      assert_equal 'Push Pull Upper', sallys_push_pull_upper['name']
      assert_equal 'Whole Body Mix', sallys_whole_body_mix['name']      
    end

    test "normalize a new routine for sally" do
      login_as(User.find_by_login('sally_the_client'))
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
      assert_equal 2, routine.activity_sets.length
    end
#      post :create, params.to_json
 
    
end
