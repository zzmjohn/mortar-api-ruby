require 'set'

module Mortar
  class API
    module Task
      STATUS_FAILURE          = "FAILURE"
      STATUS_SUCCESS          = "SUCCESS"

      STATUSES_COMPLETE       = Set.new([STATUS_FAILURE, 
                                        STATUS_SUCCESS])
    end
    
    # GET /vX/tasks/:task
    def get_task(task_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/tasks/#{task_id}")
      )
    end
    
  end
end
