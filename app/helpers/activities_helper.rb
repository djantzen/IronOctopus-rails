module ActivitiesHelper

  def activity_video_ids(activity)
    activity.activity_videos.map do |activity_video|
      activity_video.video_uri =~ /v=(\w+)/
      $1
    end
  end


end
