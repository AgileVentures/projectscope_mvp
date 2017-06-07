class Comment < ActiveRecord::Base
  belongs_to :metric_sample
  belongs_to :user

  def update_metric_sample
    origin_image = JSON.parse(metric_sample.image)
    if origin_image['data'].has_key? 'score'
      origin_image['data']['score'] = content.to_f
    end
    metric_sample.image = origin_image.to_json
    metric_sample.score = content.to_f
    metric_sample.save
  end

  def general_comment?
    ctype.eql? 'general_comment'
  end
end
