json.date do
  json.days_from_now @days_from_now
  json.date Date.today - @days_from_now.days
end

json.data do
  json.array! @projects.zip(@metric_samples) do |p, d|
    json.project_id p.id
    json.project_name p.name
    json.metric_samples d
  end
end